Spree::Core::Engine.routes.prepend do
  resources :addresses do
  	get 'delete' => "addresses#destroy", :on => :member
  end

  post 'ajax/address/retrieve_address_from_zipcode' => 'addresses#retrieve_address', :as => :retrieve_address_from_zipcode
end
