require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category fixture is valid" do
    assert categories(:hosting).valid?
  end

  test "category has expenses" do
    category = categories(:hosting)

    assert_includes category.expenses, expenses(:valid_expense)
  end
end