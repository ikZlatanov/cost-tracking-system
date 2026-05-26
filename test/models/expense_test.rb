require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  setup do
    @expense = expenses(:valid_expense)
  end

  test "valid expense fixture is valid" do
    assert @expense.valid?
  end

  test "expense requires amount" do
    @expense.amount = nil

    assert_not @expense.valid?
    assert_includes @expense.errors[:amount], "can't be blank"
  end

  test "expense amount must be greater than zero" do
    @expense.amount = 0

    assert_not @expense.valid?
    assert_includes @expense.errors[:amount], "must be greater than 0"
  end

  test "expense requires currency" do
    @expense.currency = nil

    assert_not @expense.valid?
    assert_includes @expense.errors[:currency], "can't be blank"
  end

  test "expense requires expense date" do
    @expense.expense_date = nil

    assert_not @expense.valid?
    assert_includes @expense.errors[:expense_date], "can't be blank"
  end

  test "expense requires vendor name" do
    @expense.vendor_name = nil

    assert_not @expense.valid?
    assert_includes @expense.errors[:vendor_name], "can't be blank"
  end

  test "expense description is optional" do
    @expense.description = nil

    assert @expense.valid?
  end

  test "expense belongs to project category and creator" do
    assert_equal projects(:active_project), @expense.project
    assert_equal categories(:hosting), @expense.category
    assert_equal users(:developer), @expense.creator
  end

  test "expense can be marked as zombie" do
    assert expenses(:zombie_expense).is_zombie?
  end
end