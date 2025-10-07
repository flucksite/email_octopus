require "../spec_helper"

describe EmailOctopus::RequestException do
  it "parses a request exception response" do
    exception = EmailOctopus::RequestException.from_json(
      read_fixture("exception/request.400.json").gets_to_end
    )
    exception.title.should eq("An error occurred.")
    exception.detail.should eq("Bad request.")
    exception.status.should eq(400)
    exception.errors.should be_nil
    exception.type.should eq(
      "https://emailoctopus.com/api-documentation/v2#bad-request"
    )
  end

  it "parses a validation exception response" do
    exception = EmailOctopus::RequestException.from_json(
      read_fixture("exception/validation.422.json").gets_to_end
    )
    exception.title.should eq("An error occurred.")
    exception.detail.should eq("Unprocessable content.")
    exception.status.should eq(422)
    exception.errors.should be_a(Array(EmailOctopus::RequestException::Error))
    exception.type.should eq(
      "https://emailoctopus.com/api-documentation/v2#unprocessable-content"
    )
  end
end
