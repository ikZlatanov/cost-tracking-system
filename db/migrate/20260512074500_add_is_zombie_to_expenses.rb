class AddIsZombieToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :is_zombie, :boolean
  end
end
