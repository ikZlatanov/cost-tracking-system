class DashboardsController < ApplicationController

  def analytics
    authorize :dashboard, :admin? 

    @expenses = Expense.includes(:project, :category, :creator)

    if params[:start_date].present? && params[:end_date].present?
      @expenses = @expenses.where(expense_date: params[:start_date]..params[:end_date])
    end

    @expenses = @expenses.where(currency: params[:currency]) if params[:currency].present?
    @expenses = @expenses.where(status: params[:status]) if params[:status].present?

    @totals_by_currency = @expenses.group(:currency).sum(:amount)
    @category_data = @expenses.joins(:category).group('categories.name').sum(:amount)
    @monthly_trend = @expenses.group_by_month(:expense_date).sum(:amount) rescue {}
  end

  def admin
    @projects = Project.includes(:expenses, :manager, expenses: [:category, :creator])

    # --- NEW: Fetch Zombie Expenses ---
    @zombie_expenses = Expense.where(is_zombie: true, status: 'Pending').includes(:project)

    if params[:project_id].present?
      @projects = @projects.where(id: params[:project_id])
    else
      @projects = @projects.all
    end
  end

  def project_manager
  end

  def developer
  end
end