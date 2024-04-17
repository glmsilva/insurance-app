require 'rails_helper'

describe 'Index Policies', type: :request do
  describe 'GET /policies' do
    let(:query) do 
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
    end


    before do
      stub_request(:post, "insurance-graphql:4000/graphql")
        .with(body: {query: query, variables: {} }.to_json)
    end

    it 'views policies with success' do
      get policies_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Número da Apólice: 01")
    end
  end
end
