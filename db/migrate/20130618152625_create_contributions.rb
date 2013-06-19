class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.float :quota
      t.string :servizio
      t.integer :numero

      t.timestamps
    end
  end
end
