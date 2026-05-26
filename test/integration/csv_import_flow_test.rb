require "test_helper"

class CsvImportFlowTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
  end

  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password123"
    }

    assert_redirected_to admin_dashboard_path
  end

    test "admin can upload a valid csv" do
    login_as(@admin)

    assert_difference "CsvImport.count", 1 do
      post csv_imports_path, params: {
        file: fixture_file_upload("valid_expenses.csv", "text/csv")
      }
    end

    assert_response :redirect
  end


    test "csv import is rejected when no file is uploaded" do
    login_as(@admin)

    assert_no_difference "CsvImport.count" do
      post csv_imports_path, params: {
        file: nil
      }
    end

    assert_response :unprocessable_content
  end

  test "unauthenticated user cannot upload csv" do
    assert_no_difference "CsvImport.count" do
      post csv_imports_path, params: {
        csv_import: {
          file: fixture_file_upload("valid_expenses.csv", "text/csv")
        }
      }
    end

    assert_redirected_to login_path
  end
end