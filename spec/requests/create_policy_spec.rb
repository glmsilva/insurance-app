require 'rails_helper'

describe 'Create Policy', type: :request do
  describe 'POST /policies' do
    context 'when all fields filled correctly' do
      let(:params) do
        {
          insured_person: {
            name: 'Manuel Neuer',
            cpf: '123.456.789-10'
          },
          vehicle: {
            brand: 'Fiat',
            model: 'Uno',
            year: '2001',
            license_plate: 'ABC1D23'
          }
        }
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

      let(:variables) do
        {
          input: {
            insuredPerson: {
              name: 'Manuel Neuer',
              cpf: '123.456.789-10'
            },
            vehicle: {
              brand: 'Fiat',
              model: 'Uno',
              year: '2001',
              licensePlate: 'ABC1D23'
            }
          }
        }.to_json
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
        token = JWT.encode({}, ENV['JWT_SECRET'], 'HS256')
        user = build(:user)
        sign_in user

        post policies_path, headers: { 'AUTHORIZATION' => "Bearer #{token}" }, params: params

        expect(response).to have_http_status(200)
      end
    end
  end
end
