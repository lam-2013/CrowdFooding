class AddTitoloToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :titolo, :string
    add_column :projects, :descrizione, :string
    add_column :projects, :categoria, :string
    add_column :projects, :data_creazione, :datetime
    add_column :projects, :data_fine, :datetime
    add_column :projects, :tags, :string
    add_column :projects, :images, :string
    add_column :projects, :videos, :string
    add_column :projects, :budget_attuale, :float
    add_column :projects, :goal, :float
    add_column :projects, :img_copertina, :string
    add_column :projects, :risorse_umane, :string
    add_column :projects, :gift, :string

    add_column :users, :cognome, :string
    add_column :users, :sesso, :string
    add_column :users, :nascita, :date
    add_column :users, :luogo, :string
    add_column :users, :img_copertina, :string
    add_column :users, :descrizione, :string
    add_column :users, :sito_web, :string
    add_column :users, :occupazione, :string
  end
end
