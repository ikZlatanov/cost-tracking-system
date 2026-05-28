require "application_system_test_case"

class ExpenseFlowTest < ApplicationSystemTestCase
  test "developer creates a manual expense" do
    visit login_path

    fill_in "email", with: "dev@wollow.com"
    fill_in "password", with: "password123"

    click_button "Sign in"

    visit new_expense_path

    select "Wollow Platform", from: "expense_project_id"
    select "Hosting", from: "expense_category_id"

    fill_in "expense_amount", with: "250.75"

    select "EUR", from: "expense_currency"

    fill_in "expense_expense_date", with: "2026-05-27"

    fill_in "expense_vendor_name", with: "Amazon AWS"

    fill_in "expense_description", with: "Monthly infrastructure hosting"

    click_button "Log Expense"

    assert_text "EXPENSE LOGGED"

    assert_text "Amazon AWS"

    assert_text "EUR 250.75"
  end
end