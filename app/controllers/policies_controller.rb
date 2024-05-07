class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all
  end

  def create
    head :ok
  end
end
