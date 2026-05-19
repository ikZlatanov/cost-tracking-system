class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :client_name
      t.integer :manager_id
      t.string :status
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :projects, :manager_id
  end
end
