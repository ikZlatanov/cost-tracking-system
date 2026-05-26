require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page responds successfully" do
    get root_path

    assert_response :success
  end

  test "login page responds successfully" do
    get login_path

    assert_response :success
  end
end