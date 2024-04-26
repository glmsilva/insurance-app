class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :generate_token

  private

  def generate_token
    @token = JWT.encode({}, 'banana', 'HS256')
  end
end
