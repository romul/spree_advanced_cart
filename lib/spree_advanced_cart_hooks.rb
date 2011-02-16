class SpreeAdvancedCartHooks < Spree::ThemeSupport::HookListener
  insert_after :inside_head do
    "<%= stylesheet_link_tag 'advanced_cart' %>"
  end
end

