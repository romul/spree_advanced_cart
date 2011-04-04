class AdvancedCartConfiguration < Configuration
  preference :enable_coupon_applying, :boolean, :default => true
  preference :enable_shipping_cost_calculation, :boolean, :default => true
  preference :skip_zipcode_validation, :boolean, :default => false
end
