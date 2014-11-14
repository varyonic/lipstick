require 'helper'

include Lipstick::Fixtures

describe 'Lipstick::Api::Session' do
  before(:each) do
    params = fixtures(:credentials)
    params[:logger] = Logger.new(STDOUT) if ENV['DEBUG_LIPSTICK'] == 'true'
    @session = Lipstick::Api::Session.new(params)
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

  describe '#shipping_method_find' do
    it "finds shipping methods" do
      api_response = @session.shipping_method_find
      assert api_response.code == 100
      assert api_response.respond_to?(:shipping_ids) == true, "Does not respond to shipping_ids"
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
end
