require "habitat"

module EmailOctopus
  class Client
    Habitat.create do
      setting endpoint : String = "https://api.emailoctopus.com/"
      setting api_key : String
    end

    enum Method
      GET
      POST
      PUT
      DELETE
    end

    private def perform_http_call(
      method : Method,
      path : String,
      body : BodyData? = nil,
      query : QueryData = QueryData.new,
      content_type : String = "application/json",
    )
      case method
      in Method::GET
        render(
          HTTP::Client.get(
            build_uri(path, query),
            headers: headers(path, content_type)
          )
        )
        {% for method in %i[post put delete] %}
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
        "Authorization" => "Bearer #{EmailOctopus::Client.settings.api_key}",
      }
    end

    private def build_uri(
      path : String,
      query : QueryData,
    ) : String
      uri = URI.parse(EmailOctopus::Client.settings.endpoint)
      uri.path = path
      uri.query = URI::Params.encode(query)
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
