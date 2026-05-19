class DashboardPolicy < ApplicationPolicy
  def admin?
    user.role == 'admin'
  end

  def analytics?
    admin?
  end
end