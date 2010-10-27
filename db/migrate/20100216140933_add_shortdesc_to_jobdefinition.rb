class AddShortdescToJobdefinition < ActiveRecord::Migration
  def self.up
    add_column :jobdefinitions, :short_desc, :string
  end

  def self.down
    remove_column :jobdefinitions, :short_desc
  end
end
