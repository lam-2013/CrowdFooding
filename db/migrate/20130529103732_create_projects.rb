class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id

      t.timestamps
    end
    # index to help us retrieve all the projects associated with a given user in reverse order
    add_index :projects, [:user_id, :created_at]
  end
end
