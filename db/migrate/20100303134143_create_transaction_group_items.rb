class CreateTransactionGroupItems < ActiveRecord::Migration
  def self.up
    create_table :transaction_group_items do |t|
      t.references  :transaction_group
      t.string      :pm_transaction
      t.number      :order_number

      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_group_items
  end
end
