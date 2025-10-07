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
      when Method::GET
        render(
          HTTP::Client.get(
            build_uri(path, query),
            headers: headers(path, content_type)
          )
        )
      else
        render(
          HTTP::Client.post(
            build_uri(path, query),
            headers: headers(path, content_type),
            body: body
          )
        )
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
        "Authorization" => "Bearer #{EmailOctopus.settings.api_key}",
      }
    end

    private def render(response : HTTP::Client::Response) : String
      case response.status_code
      when 200, 201
        response.body
      when 204
        ""
      when 422
        raise EmailOctopus::ValidationError.from_json(response.body)
      when 400..499
        raise EmailOctopus::RequestError.from_json(response.body)
      else
        raise response.body
      end
    end
  end
end
