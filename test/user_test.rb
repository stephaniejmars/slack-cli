require_relative 'test_helper'
require_relative '../lib/user'

describe "User" do 
  describe "self.get" do 
    it "gets a list of users and returns them as an httparty Response" do 
      result = {}
      VCR.use_cassette("users-list-endpoint") do 
        result = User.get("https://slack.com/api/users.list")
      end 
      expect(result).must_be_kind_of HTTParty::Response
      expect(result["ok"]).must_equal true
    end
    it "raises an error when a call fails" do 
      VCR.use_cassette("users-list-endpoint") do 
        expect {User.get("https://slack.com/api/bogus.endpoint")}.must_raise SlackAPIError
      end
    end
    describe "self.list" do 
      it "return a valid list of the users" do 
        result = []

        VCR.use_cassette("users-list-endpoint") do 
          result = User.list_all
        end 
      end 

    end 
  end
end