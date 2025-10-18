require "../spec_helper"

describe EmailOctopus::Contact do
  describe ".create_or_update" do
    it "creates or updates a contact" do
      WebMock.stub(:put, test_url_for("lists/00000000-0000-0000-0000-000000000000/contacts"))
        .with(body: "{\"email_address\":\"otto@example.com\"}")
        .to_return(body: read_fixture("contact/create_or_update.200.json").gets_to_end)

      EmailOctopus::Contact.create_or_update(
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: "otto@example.com",
        client: default_api_client,
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

      EmailOctopus::Contact.create_or_update(
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: params[:email_address],
        fields: params[:fields],
        tags: params[:tags],
        status: params[:status],
        client: default_api_client,
      )
    end

    it "returns the updated record" do
      WebMock.stub(:put, test_url_for("lists/00000000-0000-0000-0000-000000000000/contacts"))
        .to_return(body: read_fixture("contact/create_or_update.200.json").gets_to_end)

      contact = EmailOctopus::Contact.create_or_update(
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: "otto@example.com",
        client: default_api_client,
      )
      contact.id.should eq("00000000-0000-0000-0000-000000000000")
      contact.email_address.should eq("otto@example.com")
      contact.fields.should be_a(Hash(String, EmailOctopus::FieldValue))
      contact.tags.should eq(%w[vip])
      contact.status.should eq(EmailOctopus::Contact::Status::Subscribed)
      contact.created_at.should be_a(Time)
      contact.last_updated_at.should be_a(Time)
    end

    it "handles inconsistent data types in fields value" do
      contact = EmailOctopus::Contact.from_json(
        read_fixture("contact/create_or_update_array.200.json").gets_to_end
      )
      contact.fields.should eq({} of String => EmailOctopus::FieldValue)
    end
  end
end
