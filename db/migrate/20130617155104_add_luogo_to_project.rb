class AddLuogoToProject < ActiveRecord::Migration
  def change
    add_column :projects, :luogo, :string
  end
end
