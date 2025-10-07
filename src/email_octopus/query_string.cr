module EmailOctopus
  struct QueryString
    getter query : Hash(String, String)

    def initialize(raw_query : QueryData)
      @query = sanitized_raw_query(raw_query)
    end

    def build : String
      URI::Params.encode(@query)
    end

    private def sanitized_raw_query(
      raw_query : QueryData,
    ) : Hash(String, String)
      raw_query
        .map { |k, v| {k, v.to_s} }
        .to_h
        .reject { |_, v| v.blank? }
    end
  end
end
