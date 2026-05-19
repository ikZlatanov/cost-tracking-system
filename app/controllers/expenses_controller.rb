class ExpensesController < ApplicationController
  before_action :require_login 
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    authorize Expense 

    # 1. Base query with eager loading to prevent N+1 performance issues
    @expenses = Expense.includes(:project, :category, :creator).order(expense_date: :desc)

    # 2. Date Range Filter
    if params[:start_date].present? && params[:end_date].present?
      @expenses = @expenses.where(expense_date: params[:start_date]..params[:end_date])
    end

    # 3. Project Filter
    if params[:project_id].present?
      @expenses = @expenses.where(project_id: params[:project_id])
    end

    # 4. Vendor Filter (Uses ILIKE for case-insensitive partial matching in PostgreSQL)
    if params[:vendor_name].present?
      @expenses = @expenses.where("vendor_name ILIKE ?", "%#{params[:vendor_name]}%")
    end

    # 5. Pagination (50 records per page)
    @expenses = @expenses.page(params[:page]).per(50)
  end

  def show
    authorize @expense
  end

  def new
    @expense = Expense.new
    authorize @expense
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.creator = current_user
    authorize @expense

    if @expense.save
      flash[:notice] = "SUCCESS! \nVendor: #{@expense.vendor_name} \nAmount: #{@expense.currency} #{@expense.amount}"
      redirect_to new_expense_path
    else
      # Updated to remove the deprecation warning
      render :new, status: :unprocessable_content 
    end
  end

  def edit
    authorize @expense
    
    # Load required data for the dropdowns in the edit form
    @projects = Project.all
    @categories = Category.all
  end

  def update
    authorize @expense

    if @expense.update(expense_params)
      redirect_to @expense, notice: 'Expense was successfully updated.'
    else
      @projects = Project.all
      @categories = Category.all
      # Updated here as well
      render :edit, status: :unprocessable_content 
    end
  end

  def destroy
    authorize @expense 
    @expense.destroy
    redirect_to admin_dashboard_path, notice: "Expense securely deleted."
  end

  private
  
  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    # Added :status here so admins can update the approval status
    params.require(:expense).permit(:project_id, :category_id, :amount, :currency, :expense_date, :vendor_name, :description, :status)
  end

  def require_login
    unless current_user
      flash[:alert] = "You must be logged in to view expenses."
      redirect_to login_path
    end
  end
end