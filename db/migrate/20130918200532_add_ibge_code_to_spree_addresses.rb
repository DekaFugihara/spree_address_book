class AddIbgeCodeToSpreeAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :ibge_city_code, :string
    add_column :spree_addresses, :ibge_state_code, :string
  end
end