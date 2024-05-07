require 'rails_helper'

describe PolicyService do
  describe '#all' do
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
      stub_request(:post, "#{ENV['GRAPHQL_API_URL']}/graphql")
        .with(
          body: {
            query: query,
            variables: {}
          }.to_json)
        .to_return(body: graphql_response.to_json, status: 200)
    end

    it 'retrieves all policies' do
      service = described_class.new(query: QueryBuilderService.policies)

      expect(service.all).to eq(
        [
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
              "cpf" => "123.654.987-10"},
            "vehicle" => {
              "licensePlate" => "BDF2E34"
            },
            "effectiveDate" => "2024-01-01",
            "expirationDate" => "2025-01-01"}]
      )
    end
  end

  describe "#create_policy" do
    let(:variables) do
      {
        input: {
          insuredPerson: {
            name: 'Kilian Mbappé',
            cpf: '123.456.789-10'
          },
          vehicle: {
            brand: 'Fiat',
            model: 'Uno',
            year: '2001',
            licensePlate: 'ABC1D23'
          }
        }
      }
    end

    let(:query) do
      <<-Mutation
      mutation createPolicy($input: CreatePolicyMutationInput!) {
        createPolicy(input: $input) {
          policy {
            policyId
            insuredPerson {
              name
            }
            effectiveDate
            expirationDate
            vehicle {
              licensePlate
            }
          }
        }
      }
    Mutation
    end

    let(:graphql_response) do
      {
        data: {
          createPolicy: {
            policy: {
              policyId: 1
            }
          }
        }
      }
    end
    before do
      stub_request(:post, "#{ENV['GRAPHQL_API_URL']}/graphql")
        .with(
          body: {
            query: query,
            variables: variables
          }
        )
        .to_return(body: graphql_response.to_json, status: 200)
    end

    it 'creates a policy successfully' do
      service = described_class.new(query: QueryBuilderService.create_policy, variables: variables)
      expect(service.create).to include(
        policyId: 1
      )
    end
  end
end
