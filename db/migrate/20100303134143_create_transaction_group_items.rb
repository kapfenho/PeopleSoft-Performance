class CreateTransactionGroupItems < ActiveRecord::Migration
  def self.up
    create_table :transaction_group_items do |t|
      t.references  :transaction_group
      t.string      :pm_transaction
      t.integer     :order_number
      t.string      :system_name

      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_group_items
  end
end
