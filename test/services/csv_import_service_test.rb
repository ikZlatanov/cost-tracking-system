require "test_helper"

class CsvImportServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:developer)
  end

  test "imports expenses from valid csv file" do
    csv_import = build_csv_import("valid_expenses.csv")

    assert_difference "Expense.count", 2 do
      result = CsvImportService.new(csv_import).process!
      assert result
    end

    expense = Expense.find_by(vendor_name: "AWS")

    assert_equal BigDecimal("125.50"), expense.amount
    assert_equal "EUR", expense.currency
    assert_equal categories(:hosting), expense.category
    assert_equal @user, expense.creator
  end

  test "flags expenses as zombie when imported project is inactive" do
    csv_import = build_csv_import("valid_expenses.csv")

    CsvImportService.new(csv_import).process!

    zombie_expense = Expense.find_by(vendor_name: "Azure")

    assert zombie_expense.is_zombie?
  end

  test "returns false when csv file is malformed" do
    csv_import = build_csv_import("malformed_expenses.csv")

    assert_no_difference "Expense.count" do
      assert_not CsvImportService.new(csv_import).process!
    end
  end

  private

  def build_csv_import(filename)
    csv_import = CsvImport.new(user: @user)
    csv_import.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/#{filename}")),
      filename: filename,
      content_type: "text/csv"
    )
    csv_import.save!
    csv_import
  end
end