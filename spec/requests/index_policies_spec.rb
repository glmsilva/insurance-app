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
          vehicle {
            brand
            model
            year
            licensePlate
          }
          effectiveDate
          expirationDate
        }
      }
      Query
    end

    let(:graphql_response) do
      {
        "data" => {
          "policies" => [
            {
              "policyId" => "1",
              "insuredPerson" => {
                "name" => "Phil Foden",
                "cpf" => "123.456.789-10"
              },
              "vehicle" => {
                "licensePlate" => "ABC1D23"
              },
              "effectiveDate" => "2024-01-01",
              "expirationDate" => "2025-01-01"
            },
            {
              "policyId" => "2",
              "insuredPerson" => {
                "name" => "Edson Arantes",
                "cpf" => "123.654.987-10"
              },
              "vehicle" => {
                "licensePlate" => "BDF2E34"
              },
              "effectiveDate" => "2024-01-01",
              "expirationDate" => "2025-01-01"
            }
          ]
        }
      }

    end

    before do
      stub_request(:post, "insurance-graphql:4000/graphql")
        .with(body: {query: query, variables: {} }.to_json)
        .to_return(body: graphql_response.to_json, status: 200)
    end

    it 'views policies with success' do
      get policies_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Phil Foden")
      expect(response.body).to include("Edson Arantes")
    end

    context 'when server is down' do
      before do
        stub_request(:post, "insurance-graphql:4000/graphql")
          .with(body: {query: query, variables: {} }.to_json)
          .to_return(body: { errors: [{ message: "erro" }]}.to_json, status: 500)
      end

      it 'show any policy' do
        get policies_path

        binding.pry
        expect(response).to have_http_status(200)
        expect(response.body).to_not include("Phil Foden")
        expect(response.body).to include("Nenhuma apólice")
      end
    end
  end
end
