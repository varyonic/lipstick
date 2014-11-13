require 'helper'

include Lipstick::Fixtures

describe 'Lipstick::Api::Session' do
  before(:each) do
    @session = Lipstick::Api::Session.new(fixtures(:credentials))
  end

  describe '#shipping_method_find' do
    it "finds shipping methods" do
      api_response = @session.shipping_method_find
      assert api_response.respond_to?(:shipping_ids) == true, "Does not respond to shipping_ids"
    end
  end

  describe "validate_credentials" do
    it "returns true if credentials valid" do
      assert @session.validate_credentials == true, "Credentials not valid."
    end

    it "returns false if credentials invalid" do
      invalid_credentials = fixtures(:credentials).merge!(password: 'invalid')
      @invalid_session = Lipstick::Api::Session.new(invalid_credentials)
      assert @invalid_session.validate_credentials == false, "Invalid credentials not detected."
    end
  end
end
