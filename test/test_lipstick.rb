require 'helper'

include Lipstick::Fixtures

describe 'Lipstick::Api::Session' do
  let (:order_params) {
    {
      first_name: 'Jim',
      last_name:  'Smith',
      phone:      '(555)555-5555',
      email:      'test@test.com', # jim.smith@example.com'
      credit_card_type: 'visa',
      credit_card_number: fixtures(:test_card_number),
      expiration_date: '1219',
      "CVV" => '123',
      tran_type: 'NewOrder',
      ip_address: '127.0.0.1',
      upsell_count: 0,
    }.update(address('shipping')).update(address('billing'))
  }
  before(:each) do
    params = fixtures(:credentials)
    params[:logger] = Logger.new(STDOUT) if ENV['DEBUG_LIPSTICK'] == 'true'
    @session = Lipstick::Api::Session.new(params)
    @test_card_number = fixtures(:test_card_number)
  end

  describe '#campaign_find_active' do
    it "finds all active campaigns" do
      api_response = @session.campaign_find_active
      assert api_response.code == 100
      assert api_response.campaign_id.is_a?(Array)
      assert api_response.campaign_name.is_a?(Array)
    end
  end

  describe '#campaign_view' do
    it "fetches attributes of a campaign" do
      api_response = @session.campaign_find_active
      campaign_id = api_response.campaign_id.sample
      api_response = @session.campaign_view(campaign_id)
      assert api_response.code == 100
      assert api_response.product_id.is_a?(Array)
      assert api_response.shipping_id.is_a?(Array)
    end
  end

  context "sample campaign" do
    before (:all) do
      api_response = @session.campaign_find_active
      @campaign_id = api_response.campaign_id.sample
      @campaign = @session.campaign_view(@campaign_id)
      @product_id = @campaign.product_id.sample
      @shipping_method_id = @campaign.shipping_id.sample
    end      

    describe '#customer_find_active_product' do
      before (:each) do
        api_response = @session.new_order(order_params.merge(
          campaign_id: @campaign_id,
          product_id:  @product_id,
          shipping_id: @shipping_method_id,
          )
        )
        @customer_id = api_response.customer_id
      end

      it "fetches product ids" do
        api_response = @session.customer_find_active_product(@customer_id)
        assert api_response.code == 100
        assert api_response.product_ids.is_a?(Array)
        assert api_response.product_ids[0].is_a?(Integer)
      end
    end

    describe '#new_order' do
      it "creates order" do
        api_response = @session.new_order(order_params.merge(
          campaign_id: @campaign_id,
          product_id:  @product_id,
          shipping_id: @shipping_method_id,
          )
        )
        assert api_response.code == 100
        assert api_response.test, "Expected #{api_response.test.inspect} to be true"
        assert api_response.customer_id.is_a?(Integer), "Expected #{api_response.customer_id.inspect} to be an integer"
        assert api_response.order_id.is_a?(Integer)
        assert api_response.transaction_id == 'Not Available'
        assert api_response.auth_id == 'Not Available'
      end
    end

    describe '#order_refund' do
      before (:each) do
        api_response = @session.new_order(order_params.merge(
          campaign_id: @campaign_id,
          product_id:  @product_id,
          shipping_id: @shipping_method_id,
          )
        )
        @order_id = api_response.order_id
      end

      it "refunds the customer" do
        api_response = @session.order_refund(@order_id, 0.01)
        assert api_response.code == 100
      end
    end

    describe '#order_void' do
      before (:each) do
        api_response = @session.new_order(order_params.merge(
          campaign_id: @campaign_id,
          product_id:  @product_id,
          shipping_id: @shipping_method_id,
          )
        )
        @order_id = api_response.order_id
      end

      it "cancels a new order" do
        api_response = @session.order_void(@order_id)
        assert api_response.code == 100
      end
    end

  end

  describe '#customer_find_active_product' do
    before (:each) do
      api_response = @session.campaign_find_active
      @campaign_id = api_response.campaign_id.sample
      @campaign = @session.campaign_view(@campaign_id)
      @product_id = @campaign.product_id.sample
      @shipping_method_id = @campaign.shipping_id.sample
      api_response = @session.new_order(order_params.merge(
        campaign_id: @campaign_id,
        product_id:  @product_id,
        shipping_id: @shipping_method_id,
        )
      )
      @customer_id = api_response.customer_id
    end

    it "fetches product ids" do
      api_response = @session.customer_find_active_product(@customer_id)
      assert api_response.code == 100
      assert api_response.product_ids.is_a?(Array)
      assert api_response.product_ids[0].is_a?(Integer)
    end
  end

  describe '#shipping_method_find' do
    it "finds shipping methods" do
      api_response = @session.shipping_method_find
      assert api_response.code == 100
      assert api_response.shipping_ids.is_a?(Array)
      assert api_response.shipping_ids[0].is_a?(Integer)
    end
  end

  describe "validate_credentials" do
    it "returns true if credentials valid" do
      api_response = @session.validate_credentials
      assert api_response.code == 100, "Credentials not valid."
    end

    it "returns false if credentials invalid" do
      invalid_credentials = fixtures(:credentials).merge!(password: 'invalid')
      @invalid_session = Lipstick::Api::Session.new(invalid_credentials)
      api_response = @invalid_session.validate_credentials
      assert api_response.code == 200, "Invalid credentials not detected."
    end
  end

  describe '#underscore' do
    it 'munges whatsit' do
      foobar = @session.underscore('FooBar')
      assert foobar == 'foo_bar', ">> #{foobar} <<"
    end
  end
end
