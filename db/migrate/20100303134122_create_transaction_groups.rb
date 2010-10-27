class CreateTransactionGroups < ActiveRecord::Migration
  def self.up
    create_table :transaction_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_groups
  end
end
