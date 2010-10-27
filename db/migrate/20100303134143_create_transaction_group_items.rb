class CreateTransactionGroupItems < ActiveRecord::Migration
  def self.up
    create_table :transaction_group_items do |t|
      t.references :transaction_group
      t.string :pm_context_value1
      t.string :pm_context_value2
      t.string :pm_context_value3

      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_group_items
  end
end
