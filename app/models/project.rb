class Project < ApplicationRecord
  # A project belongs to a manager(user)
  belongs_to :manager, class_name: 'User'
  has_many :expenses
end