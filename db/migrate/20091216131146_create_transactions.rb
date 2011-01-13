class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :pm_transaction,       :null => false
      t.string :description,          :null => false
      t.text   :notes,                :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
