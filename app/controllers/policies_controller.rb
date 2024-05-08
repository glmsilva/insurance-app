class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all(@token)
  end

  def create
    @policy = PolicyService.create(input: build_input(params), token: @token)
  end

  private

  def build_input(params)
    {
      input:
        permitted_params.to_unsafe_h.deep_transform_keys { |key| key.to_s.camelize(:lower) }.deep_symbolize_keys
    }
  end

  def permitted_params
    params.permit(insured_person_params, vehicle_params)
  end

  def insured_person_params
    {
      insured_person: [
        :name,
        :cpf
      ]
    }
  end

  def vehicle_params
    {
      vehicle: [
        :brand,
        :model,
        :year,
        :license_plate
      ]
    }
  end
end
