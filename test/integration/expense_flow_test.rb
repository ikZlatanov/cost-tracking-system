require "test_helper"

class ExpenseFlowTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:active_project)
    @category = categories(:hosting)
  end

  test "authenticated user can create expense" do
    login_as(:developer)

    assert_difference "Expense.count", 1 do
      post expenses_path, params: {
        expense: {
          expense_date: Date.current,
          amount: 25.50,
          currency: "EUR",
          vendor_name: "AWS",
          description: "Test infrastructure cost",
          project_id: @project.id,
          category_id: @category.id,
          status: "Pending"
        }
      }
    end

    assert_response :redirect
  end

  test "expense is rejected with missing required data" do
    login_as(:developer)

    assert_no_difference "Expense.count" do
      post expenses_path, params: {
        expense: {
          amount: nil,
          vendor_name: "",
          project_id: nil,
          category_id: nil
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "unauthenticated user cannot create expense" do
    assert_no_difference "Expense.count" do
      post expenses_path, params: {
        expense: {
          expense_date: Date.current,
          amount: 25.50,
          currency: "EUR",
          vendor_name: "AWS",
          description: "Unauthorized test",
          project_id: @project.id,
          category_id: @category.id,
          status: "Pending"
        }
      }
    end

    assert_redirected_to login_path
  end
end