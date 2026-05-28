require "application_system_test_case"

class FullExpenseLifecycleTest < ApplicationSystemTestCase
  test "developer creates expense, project manager approves it, admin verifies it" do
    vendor = "E2E AWS #{Time.now.to_i}"

    login_as("m.jordan@wollow.com", "michaelJ123")

    visit new_expense_path

    select "Wollow Platform", from: "expense_project_id"
    select "Hosting", from: "expense_category_id"
    fill_in "expense_amount", with: "250.75"
    select "EUR", from: "expense_currency"
    fill_in "expense_expense_date", with: "2026-05-27"
    fill_in "expense_vendor_name", with: vendor
    fill_in "expense_description", with: "Full E2E lifecycle infrastructure hosting"

    click_button "Log Expense"

    assert_text "EXPENSE LOGGED"
    assert_text vendor
    assert_text "EUR 250.75"

    logout

    login_as("j.bond@wollow.com", "bond123James")

    visit expenses_path

    assert_text "Cost History Table"
    assert_text vendor
    assert_text "Pending"

    within("tr", text: vendor) do
      click_link "Edit"
    end

    assert_text "Edit Expense"
    select "Approved", from: "expense_status"
    click_button "Update Expense"

    assert_text "Approved"
    assert_text vendor

    logout

    login_as("i.zlatanov@wollow.com", "iZlatanov123")

    visit expenses_path

    assert_text "Cost History Table"
    assert_text vendor
    assert_text "Approved"
    assert_text "250.75"
    assert_text "EUR"

    visit admin_dashboard_path

    assert_text "Admin Dashboard"
    assert_text "Global Project & Expense Tracker"
    assert_text "Wollow Platform"
    assert_text vendor
    assert_text "Approved"

    visit admin_analytics_path

    assert_text "Global Financial Analytics"
    assert_text "Detailed Transaction Log"
    assert_text vendor
    assert_text "250.75 EUR"
  end

  private

  def login_as(email, password)
    visit login_path
    fill_in "email", with: email
    fill_in "password", with: password
    click_button "Sign in"
  end

  def logout
    click_button "Log Out"
  end
end