class PolicyService
  def initialize(query:, token:, variables: {})
    @conn = Faraday.new(url: ENV['GRAPHQL_API_URL'])
    @token = token
    @query = query
    @variables = variables
  end

  def all
    response = JSON.parse(graphql_call.body)

    if response.has_key? "errors"
      return []
    end
    policies = response["data"]["policies"]
  rescue Faraday::ConnectionFailed => e
    Rails.logger.info e
    return []
  end

  def self.all(token)
    new(query: QueryBuilderService.policies, token: token).all
  end

  private

  def graphql_call
    @conn.post "/graphql" do |req|
      req.headers[:content_type] = "application/json"
      req.headers[:authorization] = "Bearer #{@token}"
      req.body = { query: @query, variables: @variables }.to_json
    end
  end
end
