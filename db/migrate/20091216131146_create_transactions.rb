class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :pm_context_value1,    :null => false
      t.string :pm_context_value2,    :null => false
      t.string :pm_context_value3,    :null => false
      t.string :description,          :null => false
      t.text   :notes,                :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
