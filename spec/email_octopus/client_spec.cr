require "../spec_helper"

describe EmailOctopus::Client do
  describe ".configure" do
    it "accepts an api key" do
      EmailOctopus::Client.configure do |settings|
        settings.api_key = "eo_abc123"
      end

      EmailOctopus::Client.settings.api_key.should eq("eo_abc123")
    end

    it "has a default endpoint" do
      EmailOctopus::Client.settings.endpoint
        .should eq("https://api.emailoctopus.com/")
    end
  end
end
