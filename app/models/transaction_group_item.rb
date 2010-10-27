class TransactionGroupItem < ActiveRecord::Base
  belongs_to :transaction_group
  has_many :transhist ##, :foreign_key => ["pm_context_value1","pm_context_value2","pm_context_value3"]
end
