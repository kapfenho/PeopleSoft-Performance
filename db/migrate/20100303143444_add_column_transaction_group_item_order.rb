class AddColumnTransactionGroupItemOrder < ActiveRecord::Migration
  def self.up
    add_column :transaction_group_items, :order, :number
  end

  def self.down
    remove_column :transaction_group_items, :order
  end
end
