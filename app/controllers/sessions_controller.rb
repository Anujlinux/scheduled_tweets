class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user.present? && BCrypt::Password.new(user.password_digest) == params[:password]
      session[:user_id] = user.id
      redirect_to root_path , notice: 'Logged In Successfully'
    else
      flash[:alert] = "Invalid Email or Password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully'
  end
end 