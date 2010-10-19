class AddFieldsToCircle < ActiveRecord::Migration
  def self.up
    add_column :circles, :admin_user_id, :integer
    add_column :circles, :created_by, :integer
  end

  def self.down
    remove_column :circles, :created_by
    remove_column :circles, :admin_user_id
  end
end
