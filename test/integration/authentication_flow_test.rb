require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "admin logs in and reaches admin dashboard" do
    login_as(:admin)

    assert_redirected_to admin_dashboard_path
  end

  test "project manager logs in and reaches pm dashboard" do
    login_as(:project_manager)

    assert_redirected_to pm_dashboard_path
  end

  test "developer logs in and reaches developer dashboard" do
    login_as(:developer)

    assert_redirected_to developer_dashboard_path
  end

  test "invalid login does not authenticate user" do
    post login_path, params: {
      email: users(:developer).email,
      password: "wrong"
    }

    assert_response :unprocessable_content
    assert_equal "The password you entered is wrong.", flash[:alert]
  end

  test "user can log out" do
    login_as(:developer)

    delete logout_path

    assert_redirected_to root_path
  end
end