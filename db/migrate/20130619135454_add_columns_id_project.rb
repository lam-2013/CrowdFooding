class AddColumnsIdProject < ActiveRecord::Migration
  def change

    add_column :contributions, :project_id, :integer
  end
end
