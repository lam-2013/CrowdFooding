class AddLuogoToProject < ActiveRecord::Migration
  def change
    rename_column :projects, :Luogo, :luogo

  end
end
