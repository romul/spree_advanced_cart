=begin
Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "advanced_cart_subtotals",
                     :insert_bottom => "div#subtotal",
                     :text => %(<h5><%= t(:total) %>: <span class="order-total"><%= number_to_currency @order.total %></span></h5>)
                     ) if Spree::AdvancedCart::Config[:enable_coupon_applying]
=end
