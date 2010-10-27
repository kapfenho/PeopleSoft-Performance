class TranshistTopAvg < ActiveRecord::Base
    set_table_name "TRANSHIST_TOP_AVG"
    
    def self.csv_header
      # ""ID",Last Name,First Name,Email,Birthdate"
    end

    # Emit our attribute values as a line of CSVs
    def to_csv
      # id.to_s << "," << last_name << "," << first_name << "," << email <<    "," << birthdate.to_s
    end
end
