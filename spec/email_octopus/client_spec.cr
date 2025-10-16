require "../spec_helper"

describe EmailOctopus::Client do
  describe "#get" do
    it "gets a resource" do
      WebMock.stub(:get, "https://api.emailoctopus.com/lists")
        .to_return(body: "{}")

      default_api_client.get("/lists").should eq("{}")
    end

    it "handles api exceptions" do
      WebMock.stub(:get, "https://api.emailoctopus.com/lists").to_return(
        body: read_fixture("list/all.400.json").gets_to_end,
        status: 400
      )

      ex = expect_raises(EmailOctopus::RequestException) do
        default_api_client.get("/lists").should eq("{}")
      end
      ex.message.should eq("Bad Request. (400)")
      ex.title.should eq("An error occurred.")
      ex.detail.should eq("Bad Request.")
      ex.status.should eq(400)
      errors = ex.errors.as(Array(EmailOctopus::RequestException::Error))
      errors.first.detail.should eq("This value should be between 1 and 100.")
    end

    context "when EMAIL_OCTOPUS_API_KEY is set" do
      it "creates a client with the API key from environment" do
        ENV["EMAIL_OCTOPUS_API_KEY"] = "test-api-key"

        EmailOctopus::Client.from_env_var.should be_a(EmailOctopus::Client)

        ENV.delete("EMAIL_OCTOPUS_API_KEY")
      end
    end

    context "when EMAIL_OCTOPUS_API_KEY is not set" do
      it "raises MissingApiKeyException" do
        ENV.delete("EMAIL_OCTOPUS_API_KEY")

        expect_raises(
          EmailOctopus::MissingApiKeyException,
          "Missing 'EMAIL_OCTOPUS_API_KEY' env var"
        ) do
          EmailOctopus::Client.from_env_var
        end
      end
    end
  end
end
