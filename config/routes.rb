Spree::Core::Engine.routes.append do

  get "/estimate_shipping_cost", :to => 'orders#estimate_shipping_cost'

end