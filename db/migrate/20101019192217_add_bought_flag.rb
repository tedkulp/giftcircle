class AddBoughtFlag < ActiveRecord::Migration
  def self.up
    add_column :gifts, :bought_by_id, :integer
    add_column :gifts, :bought_date, :datetime
  end

  def self.down
    remove_column :gifts, :bought_date
    remove_column :gifts, :bought_by_id
  end
end
