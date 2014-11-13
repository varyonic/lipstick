require 'helper'

include Lipstick::Fixtures

describe 'Lipstick' do
  before(:each) do
    @session = Lipstick::Api::Session.new(fixtures(:credentials))
  end
  	
  describe "validate_credentials" do
    it "returns true if credentials valid" do
      assert @session.validate_credentials == true, "Credentials not valid."
    end
  end
end
