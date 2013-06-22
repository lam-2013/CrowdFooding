class CreateBackers < ActiveRecord::Migration
  def change
    create_table :backers do |t|
      t.integer :contribution_id
      t.integer :user_id

      t.timestamps
    end
  end
end
