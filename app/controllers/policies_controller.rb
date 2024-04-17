class PoliciesController < ApplicationController
  def index
    @policies = PolicyService.all
  end
end
