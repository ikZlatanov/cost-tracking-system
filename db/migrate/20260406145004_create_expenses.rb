class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :created_by_id
      t.references :category, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2
      t.string :currency
      t.date :expense_date
      t.string :vendor_name
      t.text :description
      t.string :status
      t.integer :checked_by_id
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :expenses, :created_by_id
    add_index :expenses, :checked_by_id
  end
end
