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

      def self.from_json(pull : JSON::PullParser)
        from_string(pull.read_string.to_s)
      end

      def self.from_string(value : String)
        from_value(names.map(&.underscore).index(value) || 0)
      end
    end

    getter id : String
    getter email_address : String
    @[JSON::Field(key: "fields")]
    getter raw_fields : Array(String) | Hash(String, FieldValue)
    getter tags : Array(String)
    getter created_at : Time
    getter status : Status
    getter last_updated_at : Time

    def fields : Hash(String, FieldValue)
      return {} of String => FieldValue if raw_fields.is_a?(Array(String))

      raw_fields.as(Hash(String, FieldValue))
    end

    def self.create_or_update(
      list_id : String,
      email_address : String,
      fields : Hash(String, FieldValue?)? = nil,
      tags : Hash(String, Bool)? = nil,
      status : Status? = nil,
      client : Client = Client.from_env_var,
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
