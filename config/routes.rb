Rails.application.routes.draw do
  match "/estimate_shipping_cost", :to => 'orders#estimate_shipping_cost', :via => :get, :as => :estimate_shipping_cost
end
