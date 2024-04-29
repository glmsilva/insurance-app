class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :generate_token

  private

  def generate_token
    @token = JWT.encode({}, ENV['JWT_SECRET'], 'HS256')
  end
end
