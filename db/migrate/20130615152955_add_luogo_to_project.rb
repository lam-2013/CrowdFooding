class AddLuogoToProject < ActiveRecord::Migration
  def change
    rename_column :projects, :Luogo, :luogo
    delete :projects, :content
  end
end
