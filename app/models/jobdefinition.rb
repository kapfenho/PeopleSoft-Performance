class Jobdefinition < ActiveRecord::Base
  
  has_many :recurrences, :dependent => :destroy
  
  validates_length_of :system_name, :within => 3..20, :message => "must be present and between 3 and 20 chars"
  validates_length_of :prcsname,    :within => 3..30, :message => "must be present and between 3 and 30 chars"
  
end

