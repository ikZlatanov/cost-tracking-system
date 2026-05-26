require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "logs in admin and redirects to admin dashboard" do
    post login_path, params: {
      email: users(:admin).email,
      password: "password123"
    }

    assert_redirected_to admin_dashboard_path
  end

  test "logs in project manager and redirects to project manager dashboard" do
    post login_path, params: {
      email: users(:project_manager).email,
      password: "password123"
    }

    assert_redirected_to pm_dashboard_path
  end

  test "logs in developer and redirects to developer dashboard" do
    post login_path, params: {
      email: users(:developer).email,
      password: "password123"
    }

    assert_redirected_to developer_dashboard_path
  end

  test "rejects blank password" do
    post login_path, params: {
      email: users(:developer).email,
      password: ""
    }

    assert_response :unprocessable_entity
    assert_equal "Please write something for your password.", flash[:alert]
  end

  test "rejects unknown email" do
    post login_path, params: {
      email: "missing@wollow.com",
      password: "password123"
    }

    assert_response :unprocessable_entity
    assert_equal "Contact administration. Account not found.", flash[:alert]
  end

  test "rejects wrong password" do
    post login_path, params: {
      email: users(:developer).email,
      password: "wrong"
    }

    assert_response :unprocessable_entity
    assert_equal "The password you entered is wrong.", flash[:alert]
  end

  test "logs out user" do
    post login_path, params: {
      email: users(:developer).email,
      password: "password123"
    }

    delete logout_path

    assert_redirected_to root_path
  end
end