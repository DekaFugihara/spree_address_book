class AddDistrictAndCpfToAddresses < ActiveRecord::Migration
  
  def change
    add_column :spree_addresses, :address_district, :string
    add_column :spree_addresses, :cpf, :string
  end  
  
end


