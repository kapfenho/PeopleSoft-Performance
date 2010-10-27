class RenameColumn < ActiveRecord::Migration
  def self.up
    rename_column :jobdefinitions, :system, :system_name
  end

  def self.down
    rename_column :jobdefinitions, :system_name, :system
  end
end
