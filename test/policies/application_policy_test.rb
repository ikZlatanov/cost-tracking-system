require "test_helper"

class ApplicationPolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:developer)
    @record = expenses(:valid_expense)
    @policy = ApplicationPolicy.new(@user, @record)
  end

  test "default policy denies index" do
    assert_not @policy.index?
  end

  test "default policy denies show" do
    assert_not @policy.show?
  end

  test "default policy denies create" do
    assert_not @policy.create?
  end

  test "default policy denies new" do
    assert_not @policy.new?
  end

  test "default policy denies update" do
    assert_not @policy.update?
  end

  test "default policy denies edit" do
    assert_not @policy.edit?
  end

  test "default policy denies destroy" do
    assert_not @policy.destroy?
  end
end