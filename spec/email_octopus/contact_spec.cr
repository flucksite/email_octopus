require "../spec_helper"

describe EmailOctopus::Contact do
  before_each do
    configure_api_key
  end

  describe ".create_or_update" do
    it "creates or updates a contact" do
      contact = EmailOctopus::Contact.create_or_update(
        list_id: "00000000-0000-0000-0000-000000000000",
        email_address: "otto@example.com"
      )
    end
  end
end
