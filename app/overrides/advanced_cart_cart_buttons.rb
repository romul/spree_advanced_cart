Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "advanced_cart_cart_buttons",
                     :insert_before => "[data-hook='cart_buttons']",
                     :partial => "spree/orders/apply_coupon")

