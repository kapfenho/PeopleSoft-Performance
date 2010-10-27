class RenameColumnTransactionGroupItemOrder < ActiveRecord::Migration
  def self.up
    rename_column :transaction_group_items, :order, :order_number
  end

  def self.down
    rename_column :transaction_group_items, :order_number, :order
  end
end
