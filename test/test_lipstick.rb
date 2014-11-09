require 'helper'

include Lipstick::Fixtures

describe 'Lipstick' do
  describe "validate_credentials" do
    it "returns true if credentials valid" do
      @session = Lipstick::Api::Session.new(fixtures(:credentials))
      assert @session.validate_credentials == true, "Credentials not valid."
    end
  end
end
