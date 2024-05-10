class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all(@token)
  end

  def new

  end

  def create
    @policy = PolicyService.create(input: build_input, token: @token)
    redirect_to policies_path
  end

  private

  def build_input
    {
      input:
        policy_params.deep_transform_keys { |key| key.to_s.camelize(:lower) }.deep_symbolize_keys
    }
  end

  def policy_params
    insured_person_params.merge(vehicle_params)

  end

  def insured_person_params
    {
      insured_person: {
        **params["[insured_person]"].to_unsafe_h
      }
    }
  end

  def vehicle_params
    {
      vehicle: {
        **params["[vehicle]"].to_unsafe_h
      }
    }
  end
end
