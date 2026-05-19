class User < ApplicationRecord
  has_secure_password 

  # Linking the User to the projects, expenses etc.
  has_many :managed_projects, class_name: 'Project', foreign_key: 'manager_id'
  has_many :created_expenses, class_name: 'Expense', foreign_key: 'created_by_id'
  has_many :checked_expenses, class_name: 'Expense', foreign_key: 'checked_by_id'
  
  # Add this missing line right here!
  has_many :csv_imports
end