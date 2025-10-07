require "json"

module EmailOctopus
  alias FieldValue = String | Int32 | Float64 | Time | Array(String)

  struct Contact
    include JSON::Serializable

    enum Status
      Pending
      Subscribed
      Unsubscribed

      def to_s
        super.downcase
      end
    end

    getter id : String
    getter email_address : String
    getter fields : Hash(String, FieldValue)
    getter tags : Array(String)
    getter created_at : Time
    getter last_updated_at : Time

    def self.create_or_update(
      client : Client,
      list_id : String,
      email_address : String,
      fields : Hash(String, FieldValue?)? = nil,
      tags : Hash(String, Bool)? = nil,
      status : Status? = nil,
    )
      Contact.from_json(
        client.put(
          "lists/#{list_id}/contacts",
          {
            "email_address" => email_address,
            "fields"        => fields,
            "tags"          => tags,
            "status"        => status,
          }.compact.to_json
        )
      )
    end
  end
end
