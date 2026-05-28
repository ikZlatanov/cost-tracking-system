require "test_helper"

class CsvImportsControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated user from new csv import page" do
    get new_csv_import_path

    assert_redirected_to login_path
  end

  test "logged in user can view new csv import page" do
    login_as(:developer)

    get new_csv_import_path

    assert_response :success
  end

  test "shows error when no file is selected" do
    login_as(:developer)

    post csv_imports_path

    assert_response :unprocessable_content
    assert_equal "Please select a CSV file to upload.", flash[:alert]
  end

  test "developer can upload valid csv file" do
    login_as(:developer)

    file = fixture_file_upload("valid_expenses.csv", "text/csv")

    assert_difference "CsvImport.count", 1 do
      assert_difference "Expense.count", 2 do
        post csv_imports_path, params: { file: file }
      end
    end

    assert_redirected_to developer_dashboard_path
  end

  test "csv upload with malformed file shows parsing error" do
    login_as(:developer)

    file = fixture_file_upload("malformed_expenses.csv", "text/csv")

    post csv_imports_path, params: { file: file }

    assert_response :unprocessable_content
    assert_equal "File uploaded, but parsing failed. Check CSV format.", flash[:alert]
  end
end