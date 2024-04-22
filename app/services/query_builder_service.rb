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
end
