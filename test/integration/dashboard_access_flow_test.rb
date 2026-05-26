require "test_helper"

class DashboardAccessFlowTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password123"
    }
  end

  test "admin can access admin dashboard" do
    login_as(users(:admin))

    get admin_dashboard_path
    assert_response :success
  end

  test "project manager can access project manager dashboard" do
    login_as(users(:project_manager))

    get pm_dashboard_path
    assert_response :success
  end

  test "developer can access developer dashboard" do
    login_as(users(:developer))

    get developer_dashboard_path
    assert_response :success
  end

end