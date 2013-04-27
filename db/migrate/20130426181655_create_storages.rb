class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :key
      t.string :password
      t.timestamp :ts

      t.timestamps
    end
  end
end
