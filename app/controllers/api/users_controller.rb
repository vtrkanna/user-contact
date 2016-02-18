class Api::UsersController < ApplicationController
  skip_before_action :restrict_access, :only => [:create, :login, :varify_email, :new]
  def new
    @user = User.new
  end
  def create
    @user= User.new(user_params)  
      respond_to do |format|
        if @user.save
          if request.env["HTTP_ACCEPT"] == "application/json"
            format.json do
              SendEmail.welcome_email(@user, "Verify your email").deliver!
              render json: @user, status: :created
            end
          else
            format.html do
              @r_user = User.find request.env["HTTP_REFERER"].split("invitation_id=").last
              @r_user.contacts.create!
              render json: {:success => "Successfully registered"} 
            end
          end
        else
          format.html { render json: {:success => "Some thing went wrong"} }
          format.json { render json: @user.errors, status: :not_created}
        end
      end
  end
  def login
    @user = User.authenticate(user_params)
    respond_to do |format|
      if @user
         format.json { render json: get_token, status: :logged_in}
      else
        format.json { render json: {:status => "Please verify your login or sign up"}, status: :not_logg_in}
      end
    end
  end
  def varify_email
    @user = User.find_by_email params[:email]
    respond_to do |format|
    if @user
        @user.update_attributes(:email_varify => true)
        format.html { render json: {:success => "Successfully registered"} }
        format.json { render json: {:success => "Successfully registered"}, status: :success}
      else
        format.json { render json: @user.errors, status: :failure!}
    end
    end
  end
    
  private

  def get_token
     if @user.api_key.blank?
     @api_key = ApiKey.create!(:user=>@user)
   else
      @user.api_key
   end
 end

  def user_params
    params.require(:user).permit!
  end
end
