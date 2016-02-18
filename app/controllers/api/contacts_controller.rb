class Api::ContactsController < ApplicationController

def create
  @user = User.find params[:user_id]
  respond_to do |format|
    if  @user.email_varify
          SendEmail.sign_up_email(contact_params["email"], "You have been invited by the #{@user.email}", @user).deliver!
          format.json { render json: {:status => "A link has been sent to user"}, status: :added}
        else
          format.json { render json: {:status=> "Please login first"}, status: :not_added}
        end
    end
end

private
def contact_params
  params.require(:contact).permit(:email)
end
end

