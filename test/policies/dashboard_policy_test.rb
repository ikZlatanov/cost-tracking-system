require "test_helper"

class DashboardPolicyTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @project_manager = users(:project_manager)
    @developer = users(:developer)
  end

  test "admin can access admin dashboard" do
    assert DashboardPolicy.new(@admin, :dashboard).admin?
  end

  test "project manager cannot access admin dashboard" do
    assert_not DashboardPolicy.new(@project_manager, :dashboard).admin?
  end

  test "developer cannot access admin dashboard" do
    assert_not DashboardPolicy.new(@developer, :dashboard).admin?
  end

  test "analytics access follows admin permission" do
    assert DashboardPolicy.new(@admin, :dashboard).analytics?
    assert_not DashboardPolicy.new(@project_manager, :dashboard).analytics?
    assert_not DashboardPolicy.new(@developer, :dashboard).analytics?
  end
end