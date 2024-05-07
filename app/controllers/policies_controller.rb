class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all(@token)
  end

  def create
    head :ok
  end
end
