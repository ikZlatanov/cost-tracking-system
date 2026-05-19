class SessionsController < ApplicationController
  def create
    # Rule 1: If password is completely empty
    if params[:password].blank?
      flash.now[:alert] = "Please write something for your password."
      render "pages/login", status: :unprocessable_entity
      return
    end

    user = User.find_by(email: params[:email])

    # Rule 2: If the email does not exist in the database
    if user.nil?
      flash.now[:alert] = "Contact administration. Account not found."
      render "pages/login", status: :unprocessable_entity
    
    # Rule 3: If email exists, check if the password matches
    elsif user.authenticate(params[:password])
      # Success! Save their ID in the session cookie
      session[:user_id] = user.id
      
      # Route them to the correct dashboard based on their role
      if user.role == "admin"
        redirect_to admin_dashboard_path
      elsif user.role == "project_manager"
        redirect_to pm_dashboard_path
      else
        redirect_to developer_dashboard_path
      end

    # Rule 4: Email exists, but password was wrong
    else
      flash.now[:alert] = "The password you entered is wrong."
      render "pages/login", status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end