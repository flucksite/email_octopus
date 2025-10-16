module EmailOctopus
  class Client
    API_BASE_URL     = "https://api.emailoctopus.com/"
    API_KEY_ENV_VAR  = "EMAIL_OCTOPUS_API_KEY"
    APPLICATION_JSON = "application/json"
    POSTABLE_METHODS = %i[post put delete]

    enum Method
      GET
      POST
      PUT
      DELETE
    end

    def self.from_env_var
      unless api_key = ENV[API_KEY_ENV_VAR]?
        raise MissingApiKeyException.new("Missing '#{API_KEY_ENV_VAR}' env var")
      end

      new(api_key)
    end

    def initialize(
      @api_key : String,
      @endpoint : String = API_BASE_URL,
    )
    end

    def get(
      resource : String,
      query : QueryData = QueryData.new,
    ) : String
      perform_http_call(Method::GET, resource, query: query)
    end

    {% for method in POSTABLE_METHODS %}
      def {{method.id}}(
        resource : String,
        body : BodyData,
        content_type : String = APPLICATION_JSON,
      ) : String
        perform_http_call(
          Method::{{method.id.upcase}},
          resource,
          body: body,
          content_type: content_type
        )
      end
    {% end %}

    private def perform_http_call(
      method : Method,
      path : String,
      body : BodyData? = nil,
      query : QueryData = QueryData.new,
      content_type : String = APPLICATION_JSON,
    )
      {% begin %}
        case method
        in Method::GET
          render(
            HTTP::Client.get(
              build_uri(path, query),
              headers: headers(path, content_type)
            )
          )
          {% for method in POSTABLE_METHODS %}
          in Method::{{method.id.upcase}}
            render(
              HTTP::Client.{{method.id}}(
                build_uri(path, query),
                headers: headers(path, content_type),
                body: body
              )
            )
          {% end %}
        end
      {% end %}
    rescue e : IO::TimeoutError
      raise TimeoutException.new(e.message)
    rescue e : IO::EOFError
      raise Exception.new(e.message)
    end

    private def headers(
      path : String,
      content_type : String,
    ) : HTTP::Headers
      HTTP::Headers{
        "Accept"        => "application/json",
        "Content-Type"  => content_type,
        "Authorization" => "Bearer #{@api_key}",
      }
    end

    private def build_uri(
      path : String,
      query : QueryData,
    ) : String
      uri = URI.parse(@endpoint)
      uri.path = path
      uri.query = QueryString.new(query).build
      uri.to_s
    end

    private def render(response : HTTP::Client::Response) : String
      case response.status_code
      when 200, 201
        response.body
      when 204
        ""
      when 400..499
        raise EmailOctopus::RequestException.from_json(response.body)
      else
        raise response.body
      end
    end
  end
end
