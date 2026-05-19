# app/policies/expense_policy.rb
class ExpensePolicy < ApplicationPolicy
  
  # Can they view the list of expenses?
  def index?
    # Everyone who is logged in can view the expense index
    user.present? 
  end

  # Can they look at a specific expense?
  def show?
    # For now, anyone logged in can view the details of an expense. 
    # (You could restrict this further later so devs only see their own!)
    user.present?
  end

  # Can they create a new expense?
  def create?
    # Developers, PMs, and Admins can all submit new expenses
    user.present?
  end

  # Can they edit/update an existing expense?
  def update?
    # Admins can edit anything.
    return true if user.role == 'admin'
    
    # PMs can ONLY edit expenses that belong to a project they manage.
    # Developers are strictly blocked (returns false).
    user.role == 'project_manager' && record.project.manager_id == user.id
  end

  # Can they delete an expense completely?
  def destroy?
    # ONLY Admins have the exclusive power to permanently delete financial records
    user.role == 'admin'
  end

  # CUSTOM ACTION: Can they approve an expense?
  def approve?
    # Same logic as update: Admins can approve all, PMs can only approve for their projects.
    return true if user.role == 'admin'
    
    user.role == 'project_manager' && record.project.manager_id == user.id
  end
end