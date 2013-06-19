class AddIndexContributions < ActiveRecord::Migration
  def change
    add_index :contributions, [:project_id, :created_at]
  end
end
