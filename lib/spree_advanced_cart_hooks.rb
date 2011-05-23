Deface::Override.new(:virtual_path => "layouts/spree_application",
                     :name => "advanced_cart_assets",
                     :insert_bottom => "head",
                     :text => "<%= stylesheet_link_tag 'advanced_cart' %><%= javascript_include_tag 'advanced_cart' %>")

