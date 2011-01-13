class CreateJobdefinitions < ActiveRecord::Migration
  def self.up
    create_table :jobdefinitions do |t|
      t.string  :system_name,  :null => false
      t.string  :prcsname,      :null => false
      t.string  :short_desc
      t.text    :description
      t.boolean :active,        :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :jobdefinitions
  end
end
