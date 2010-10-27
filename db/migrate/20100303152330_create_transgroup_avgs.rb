class CreateTransgroupAvgs < ActiveRecord::Migration
  def self.up
    create_table :transgroup_avgs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :transgroup_avgs
  end
end
