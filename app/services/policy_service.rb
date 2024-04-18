class PolicyService
  def initialize
    @conn = Faraday.new(url: "http://insurance-graphql:4000")
  end

  def all
    response = JSON.parse(graphql_call(query_all).body)
    policies = response["data"]["policies"]
  end

  def self.all
    new.all
  end

  private

  def graphql_call(query, variables = {})
    @conn.post "/graphql" do |req|
      req.headers[:content_type] = "application/json"
      req.body = { query: query, variables: variables }.to_json
    end
  end

  def query_all
    query =
      <<-Query
        query {
          policies {
            policyId
            insuredPerson {
              name
              cpf
            }
          vehicle {
            licensePlate
          }
          effectiveDate
          expirationDate
        }
      }
      Query
  end
end
