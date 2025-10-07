require "../spec_helper"

describe EmailOctopus::Contact do
  describe ".create_or_update" do
    it "creates or updates a contact" do
      WebMock.stub(:put, test_url_for("lists/00000000-0000-0000-0000-000000000000/contacts"))
        .with(body: "{\"email_address\":\"otto@example.com\"}")
        .to_return(body: read_fixture("contact/create_or_update.200.json").gets_to_end)

      contact = EmailOctopus::Contact.create_or_update(
        default_api_client,
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: "otto@example.com"
      )
    end

    it "accepts fields, tags and status" do
      params = {
        email_address: "otto@example.com",
        fields:        {
          "float" => 1.23,
          "array" => %w[a b c],
        },
        tags: {
          "b" => false,
        },
        status: EmailOctopus::Contact::Status::Subscribed,
      }

      WebMock.stub(:put, test_url_for("lists/00000000-0000-0000-0000-000000000000/contacts"))
        .with(body: params.to_json)
        .to_return(body: read_fixture("contact/create_or_update.200.json").gets_to_end)

      contact = EmailOctopus::Contact.create_or_update(
        default_api_client,
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: params[:email_address],
        fields: params[:fields],
        tags: params[:tags],
        status: params[:status]
      )
    end
  end
end
