class CreateRecurrences < ActiveRecord::Migration
  def self.up
    create_table :recurrences do |t|
      t.references  :jobdefinition, :null => false
      t.string      :recurr_type, :null => false
      t.string      :recurr_at
      t.time        :run_till
      t.boolean     :active, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :recurrences
  end
end
