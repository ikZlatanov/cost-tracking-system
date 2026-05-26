require "test_helper"

class ExpensePolicyTest < ActiveSupport::TestCase
  setup do
    @expense = expenses(:valid_expense)
    @admin = users(:admin)
    @project_manager = users(:project_manager)
    @developer = users(:developer)
  end

  test "logged in users can view expense index" do
    assert ExpensePolicy.new(@admin, Expense).index?
    assert ExpensePolicy.new(@project_manager, Expense).index?
    assert ExpensePolicy.new(@developer, Expense).index?
  end

  test "logged in users can view expense details" do
    assert ExpensePolicy.new(@admin, @expense).show?
    assert ExpensePolicy.new(@project_manager, @expense).show?
    assert ExpensePolicy.new(@developer, @expense).show?
  end

  test "logged in users can create expenses" do
    assert ExpensePolicy.new(@admin, Expense).create?
    assert ExpensePolicy.new(@project_manager, Expense).create?
    assert ExpensePolicy.new(@developer, Expense).create?
  end

  test "admin can update any expense" do
    assert ExpensePolicy.new(@admin, @expense).update?
  end

  test "project manager can update expense for managed project" do
    assert ExpensePolicy.new(@project_manager, @expense).update?
  end

  test "developer cannot update expense" do
    assert_not ExpensePolicy.new(@developer, @expense).update?
  end

  test "only admin can destroy expense" do
    assert ExpensePolicy.new(@admin, @expense).destroy?
    assert_not ExpensePolicy.new(@project_manager, @expense).destroy?
    assert_not ExpensePolicy.new(@developer, @expense).destroy?
  end

  test "admin and responsible project manager can approve expense" do
    assert ExpensePolicy.new(@admin, @expense).approve?
    assert ExpensePolicy.new(@project_manager, @expense).approve?
    assert_not ExpensePolicy.new(@developer, @expense).approve?
  end
end