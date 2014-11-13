require 'helper'

include Lipstick::Fixtures

describe 'Lipstick::Api::Session' do
  before(:each) do
    params = fixtures(:credentials)
    params[:logger] = Logger.new(STDOUT) if ENV['DEBUG_LIPSTICK'] == 'true'
    @session = Lipstick::Api::Session.new(params)
  end

  describe '#shipping_method_find' do
    it "finds shipping methods" do
      api_response = @session.shipping_method_find
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
