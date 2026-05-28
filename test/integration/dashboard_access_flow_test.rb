require "test_helper"

class DashboardAccessFlowTest < ActionDispatch::IntegrationTest
  test "admin can access admin dashboard" do
    login_as(:admin)

    get admin_dashboard_path

    assert_response :success
  end

  test "project manager can access project manager dashboard" do
    login_as(:project_manager)

    get pm_dashboard_path

    assert_response :success
  end

  test "developer can access developer dashboard" do
    login_as(:developer)

    get developer_dashboard_path

    assert_response :success
  end
end