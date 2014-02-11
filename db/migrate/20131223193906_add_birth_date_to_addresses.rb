class AddBirthDateToAddresses < ActiveRecord::Migration
  
  def change
    add_column :spree_addresses, :birth_date, :date
  end  
  
end