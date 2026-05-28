require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "admin can access admin dashboard" do
    login_as(:admin)

    get admin_dashboard_path

    assert_response :success
  end

  test "admin can access analytics dashboard" do
    login_as(:admin)

    get admin_analytics_path

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

  test "developer cannot access analytics dashboard" do
    login_as(:developer)

    get admin_analytics_path

    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end
end