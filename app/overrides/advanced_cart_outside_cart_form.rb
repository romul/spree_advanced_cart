Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "advanced_cart_after_empty_cart",
                     :insert_after => "div#empty-cart",
                     :partial => "spree/orders/shipping_cost_calculation")
