require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense = expenses(:valid_expense)
    @project = projects(:active_project)
    @category = categories(:hosting)
  end

  test "redirects unauthenticated user from expenses index" do
    get expenses_path

    assert_redirected_to login_path
  end

  test "developer can view new expense page" do
    login_as(:developer)

    get new_expense_path

    assert_response :success
  end

  test "developer can create valid expense" do
    login_as(:developer)

    assert_difference "Expense.count", 1 do
      post expenses_path, params: {
        expense: {
          project_id: @project.id,
          category_id: @category.id,
          amount: 55.25,
          currency: "EUR",
          expense_date: "2026-05-20",
          vendor_name: "DigitalOcean",
          description: "Test server",
          status: "Pending"
        }
      }
    end

    assert_redirected_to new_expense_path
  end

  test "invalid expense returns unprocessable entity" do
    login_as(:developer)

    post expenses_path, params: {
      expense: {
        project_id: @project.id,
        category_id: @category.id,
        amount: nil,
        currency: "EUR",
        expense_date: "2026-05-20",
        vendor_name: "DigitalOcean",
        status: "Pending"
      }
    }

    assert_response :unprocessable_content
  end

  test "admin can destroy expense" do
    login_as(:admin)

    assert_difference "Expense.count", -1 do
      delete expense_path(@expense)
    end

    assert_redirected_to admin_dashboard_path
  end

  private

  def login_as(user_fixture)
    user = users(user_fixture)

    post login_path, params: {
      email: user.email,
      password: "password123"
    }
  end

    test "logged in user can view expenses index" do
    login_as(:admin)

    get expenses_path

    assert_response :success
  end

  test "expenses index supports project filter" do
    login_as(:admin)

    get expenses_path, params: { project_id: projects(:active_project).id }

    assert_response :success
  end

  test "expenses index supports vendor filter" do
    login_as(:admin)

    get expenses_path, params: { vendor_name: "AWS" }

    assert_response :success
  end

  test "admin can view expense details" do
    login_as(:admin)

    get expense_path(@expense)

    assert_response :success
  end

  test "admin can edit expense" do
    login_as(:admin)

    get edit_expense_path(@expense)

    assert_response :success
  end

  test "admin can update valid expense" do
    login_as(:admin)

    patch expense_path(@expense), params: {
      expense: {
        amount: 199.99,
        currency: "EUR",
        expense_date: "2026-05-22",
        vendor_name: "Updated Vendor",
        project_id: @project.id,
        category_id: @category.id,
        status: "Approved"
      }
    }

    assert_redirected_to expense_path(@expense)
    assert_equal "Updated Vendor", @expense.reload.vendor_name
  end

  test "admin update with invalid expense returns unprocessable content" do
    login_as(:admin)

    patch expense_path(@expense), params: {
      expense: {
        amount: nil,
        currency: "EUR",
        expense_date: "2026-05-22",
        vendor_name: "Updated Vendor",
        project_id: @project.id,
        category_id: @category.id
      }
    }

    assert_response :unprocessable_content
  end
end