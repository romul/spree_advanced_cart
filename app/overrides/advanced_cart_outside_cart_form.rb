Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "advanced_cart_outside_cart_form",
                     :insert_after => "[data-hook='outside_cart_form']",
                     :partial => "spree/orders/shipping_cost_calculation")

