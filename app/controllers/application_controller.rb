class ApplicationController < ActionController::Base
  # 1. This line injects Pundit's 'authorize' power into all your controllers
  include Pundit::Authorization

  # Expose both methods to your views
  helper_method :current_user, :user_dashboard_path

  # 2. This intercepts the error if someone tries to do something they aren't allowed to
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Our new dynamic route helper
  def user_dashboard_path
    return root_path unless current_user 

    case current_user.role
    when "admin"
      admin_dashboard_path
    when "project_manager"
      pm_dashboard_path
    else
      developer_dashboard_path
    end
  end

  private

  # 3. This safely redirects the rule-breaker and shows them a warning message
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    # Redirects them back to wherever they came from, or to the root page as a fallback
    redirect_back fallback_location: root_path 
  end
end