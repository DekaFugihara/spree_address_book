Spree::Core::Engine.routes.prepend do
  resources :addresses
  post 'ajax/address/retrieve_address_from_zipcode' => 'addresses#retrieve_address', :as => :retrieve_address_from_zipcode
end
