require 'helper'

include Lipstick::Fixtures

describe 'Lipstick::Api::Session' do
  i_suck_and_my_tests_are_order_dependent!

  before(:each) do
    params = fixtures(:credentials)
    params[:logger] = Logger.new(STDOUT) if ENV['DEBUG_LIPSTICK'] == 'true'
    @session = Lipstick::Api::Session.new(params)
  end

  describe '#campaign_find_active' do
    it 'finds all active campaigns' do
      api_response = @session.campaign_find_active
      assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
      assert api_response.campaign_id.is_a?(Array)
      assert api_response.campaign_id[0].is_a?(Integer)
      assert api_response.campaign_name.is_a?(Array)
    end
  end

  describe '#campaign_view' do
    it 'fetches attributes of a campaign' do
      api_response = @session.campaign_find_active
      assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
      campaign_id = api_response.campaign_id.sample
      api_response = @session.campaign_view(campaign_id)
      assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
      assert api_response.product_id.is_a?(Array)
      assert api_response.shipping_id.is_a?(Array)
    end
  end

  context 'sample campaign' do
    let(:order_params) do
      {
        campaign_id: @campaign_id,
        product_id:  @product_id,
        first_name: 'Jim',
        last_name:  'Smith',
        phone:      '(555)555-5555',
        email:      'test@test.com', # jim.smith@example.com'
        credit_card_type: @credit_card_type,
        credit_card_number: fixtures(:test_card_number),
        expiration_date: '1219',
        'CVV' => '123',
        tran_type: 'NewOrder',
        shipping_id: @shipping_method_id,
        ip_address: '127.0.0.1',
        upsell_count: 0
      }.update(address('shipping')).update(address('billing'))
    end
    before (:all) do
      api_response = @session.campaign_find_active
      assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
      @campaign_id = api_response.campaign_id.sample
      @campaign = @session.campaign_view(@campaign_id)
      @product_id = @campaign.product_id.sample
      @credit_card_type = @campaign.payment_name.sample
      @shipping_method_id = @campaign.shipping_id.sample
    end

    describe '#new_order' do
      it 'creates order' do
        api_response = @session.new_order(order_params)
        assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        assert api_response.test, "Expected #{api_response.test.inspect} to be true"
        assert api_response.customer_id.is_a?(Integer), "Expected #{api_response.customer_id.inspect} to be an integer"
        assert api_response.order_id.is_a?(Integer)
        assert api_response.transaction_id == 'Not Available'
        assert api_response.auth_id == 'Not Available'
      end
    end

    context 'existing order' do
      before (:all) do
        api_response = @session.new_order(order_params)
        assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        @order_id = api_response.order_id
        @customer_id = api_response.customer_id
      end

      describe '#customer_find_active_product' do
        it 'fetches product ids' do
          api_response = @session.customer_find_active_product(@customer_id)
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
          assert api_response.product_ids.is_a?(Array)
          assert api_response.product_ids[0].is_a?(Integer)
        end
      end

      describe '#order_find' do
        it 'returns orders matching criteria' do
          api_response = @session.order_find(Time.now - 120, Time.now)
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
          assert api_response.order_ids.is_a?(Array)
          assert api_response.order_ids[0].is_a?(Integer)
        end
      end

      describe '#order_refund' do
        it 'refunds the customer' do
          api_response = @session.order_refund(@order_id, 0.01)
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end
      end

      describe '#order_view' do
        it 'returns details of an order' do
          api_response = @session.order_view(@order_id)
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end
      end

      describe '#order_update1' do
        it 'posts chages to an order' do
          api_response = @session.order_update(@order_id, :tracking_number, 'LC123456789012345678US')
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end
      end

      context 'updated order' do
        before (:each) do
          api_response = @session.order_update(@order_id, :tracking_number, 'LC123456789012345678US')
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end

        describe '#order_find_updated' do
          it 'finds updated orders' do
            api_response = @session.order_find_updated(Time.now - 128, Time.now)
            assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
            assert api_response.order_ids.is_a?(Array)
            assert api_response.order_ids[0].is_a?(Integer)
          end
        end
      end
    end # existing order

    context 'new order' do
      before (:each) do
        api_response = @session.new_order(order_params)
        assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        @new_order_id = api_response.order_id
      end

      describe '#order_update_recurring' do
        it 'cancels a new order' do
          api_response = @session.order_update_recurring(@new_order_id, 'stop')
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end
      end

      describe '#order_void' do
        it 'cancels a new order' do
          api_response = @session.order_void(@new_order_id)
          assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
        end
      end
    end
  end # sample campaign

  describe '#shipping_method_find' do
    it 'finds shipping methods' do
      api_response = @session.shipping_method_find
      assert api_response.code == 100, "unexpected response: #{api_response.inspect}"
      assert api_response.shipping_ids.is_a?(Array)
      assert api_response.shipping_ids[0].is_a?(Integer)
    end
  end

  describe 'validate_credentials' do
    it 'returns true if credentials valid' do
      api_response = @session.validate_credentials
      assert api_response.code == 100, 'Credentials not valid.'
    end

    it 'returns false if credentials invalid' do
      invalid_credentials = fixtures(:credentials).merge!(password: 'invalid')
      @invalid_session = Lipstick::Api::Session.new(invalid_credentials)
      api_response = @invalid_session.validate_credentials
      assert api_response.code == 200, 'Invalid credentials not detected.'
    end
  end

  describe '#underscore' do
    it 'munges whatsit' do
      foobar = @session.underscore('FooBar')
      assert foobar == 'foo_bar', ">> #{foobar} <<"
    end
  end
end
