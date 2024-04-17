class PolicyService
  def initialize
    @conn = Faraday.new(url: "http://insurance-graphql:4000")
  end

  def all
    query =
      <<-Query
        query {
          policies {
            policyId
            insuredPerson {
              name
              cpf
            }
          }
        }
      Query

    response = @conn.post "/graphql" do |req|
      req.headers[:content_type] = "application/json"
      req.body = { query: query, variables: {} }.to_json
    end
  end

  def self.all
    new.all
  end

end
