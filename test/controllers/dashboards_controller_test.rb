require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get admin" do
    get dashboards_admin_url
    assert_response :success
  end

  test "should get project_manager" do
    get dashboards_project_manager_url
    assert_response :success
  end

  test "should get developer" do
    get dashboards_developer_url
    assert_response :success
  end
end
