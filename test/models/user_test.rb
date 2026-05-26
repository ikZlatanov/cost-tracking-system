require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user fixture is valid" do
    assert users(:developer).valid?
  end

  test "user can authenticate with correct password" do
    user = users(:developer)

    assert user.authenticate("password123")
  end

  test "user does not authenticate with wrong password" do
    user = users(:developer)

    assert_not user.authenticate("wrong-password")
  end

  test "project manager has managed projects" do
    manager = users(:project_manager)

    assert_includes manager.managed_projects, projects(:active_project)
  end

  test "developer has created expenses" do
    developer = users(:developer)

    assert_includes developer.created_expenses, expenses(:valid_expense)
  end
end