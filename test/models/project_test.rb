require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "valid project fixture is valid" do
    assert projects(:active_project).valid?
  end

  test "project belongs to manager" do
    project = projects(:active_project)

    assert_equal users(:project_manager), project.manager
  end

  test "project has expenses" do
    project = projects(:active_project)

    assert_includes project.expenses, expenses(:valid_expense)
  end
end