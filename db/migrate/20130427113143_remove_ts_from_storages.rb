class RemoveTsFromStorages < ActiveRecord::Migration
  def up
    remove_column :storages, :ts
  end

  def down
    add_column :storages, :ts, :timestamp
  end
end
