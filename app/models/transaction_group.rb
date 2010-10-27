class TransactionGroup < ActiveRecord::Base
  has_many :transaction_group_items, :dependent => :destroy
  
end
