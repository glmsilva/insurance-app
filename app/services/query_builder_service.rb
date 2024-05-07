class QueryBuilderService
  def self.policies
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

  def self.policy
    <<-Query
      query {
        Policy($policyId: Int!) {
          policy(PolicyId: $policyId) {
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
      }
    Query
  end

  def self.create_policy
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
end
