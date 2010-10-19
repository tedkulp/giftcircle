class AddSecretCode < ActiveRecord::Migration
  def self.up
    add_column :users, :secret_code, :string
  end

  def self.down
    remove_column :users, :secret_code
  end
end
