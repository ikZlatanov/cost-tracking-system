class Expense < ApplicationRecord
  belongs_to :project
  belongs_to :category
  
  # Linking the custom ID fields back to the User table
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :checker, class_name: 'User', foreign_key: 'checked_by_id', optional: true 

  # --- NEW VALIDATIONS ---
  # Ensures amount is filled out and is greater than zero
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  # Ensures these specific text/date fields are not left blank
  validates :currency, presence: true
  validates :expense_date, presence: true
  validates :vendor_name, presence: true
  
  # Note: We are leaving :description off this list so it remains optional!
end