class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all(@token)
  end
end
