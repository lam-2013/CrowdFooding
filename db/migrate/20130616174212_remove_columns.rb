class RemoveColumns < ActiveRecord::Migration
  def up
    remove_column :projects, :content
  end

  def down
  end
end
