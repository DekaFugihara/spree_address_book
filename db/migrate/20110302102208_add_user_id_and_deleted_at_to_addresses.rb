class AddUserIdAndDeletedAtToAddresses < ActiveRecord::Migration
  def self.up
    change_table addresses_table_name do |t|
      t.integer :user_id
      t.datetime :deleted_at
      t.string :address_type
      t.string :address_number
      t.string :phone_ddd
    end
  end

  def self.down
    change_table addresses_table_name do |t|
      t.remove :deleted_at
      t.remove :user_id
      t.remove :address_type
      t.remove :address_number
      t.remove :phone_ddd
    end
  end
  
  private
  
  def self.addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end
end
