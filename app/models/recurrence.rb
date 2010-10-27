class Recurrence < ActiveRecord::Base
  belongs_to :jobdefinition
  
  TYPE = [
    [ 'daily',  'DAILY' ],
    [ 'weekly', 'WEEKLY' ],
    [ 'monthly', 'MONTHLY' ]
  ]

  TYPE_AT = {
    :daily => nil,
    :weekly => Date::DAYNAMES,
    :mothly => 1..31
#    :every => ["5 min", "10 min"]
  }
  
end
