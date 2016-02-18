class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  skip_before_action :verify_authenticity_token, if: :json_request?
  
  before_action :restrict_access
  def json_request?
     request.format.json?
  end
  

  private
  
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find params[:user_id]
      (@user.api_key(:access_token).present?) and (ActionController::HttpAuthentication::Token.encode_credentials(@user.api_key.access_token) == request.env["HTTP_AUTHORIZATION"])
    end
  end
end
