require "json"

module EmailOctopus
  class Exception < Exception; end

  class RequestException < EmailOctopus::Exception
    def initialize(@mapper : Mapper)
    end

    def self.from_json(json : String)
      new(Mapper.from_json(json))
    end

    delegate title, detail, status, type, errors, to: @mapper

    def to_s
      message
    end

    struct Mapper
      include JSON::Serializable

      getter title : String
      getter detail : String
      getter status : Int32
      getter errors : Array(Error)?
      getter type : String
    end

    struct Error
      include JSON::Serializable

      getter detail : String
      getter pointer : String
    end
  end

  class Client
    class TimeoutException < EmailOctopus::Exception; end
  end
end
