class PolicyService
  def initialize(query:, variables: {})
    @conn = Faraday.new(url: "http://insurance-graphql:4000")
    @query = query
    @variables = variables
  end

  def all
    response = JSON.parse(graphql_call.body)
    policies = response["data"]["policies"]
  end

  def self.all
    new(query: QueryBuilderService.policies).all
  end

  private

  def graphql_call
    @conn.post "/graphql" do |req|
      req.headers[:content_type] = "application/json"
      req.body = { query: @query, variables: @variables }.to_json
    end
  end
end
