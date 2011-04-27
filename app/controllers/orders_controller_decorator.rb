OrdersController.class_eval do

  def update
    @order = current_order
    if @order.update_attributes(params[:order])
      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      if request.xhr?
        @order.update!
      else
        redirect_to cart_path
      end
    else
      render :edit unless request.xhr?
    end
  end
  
  def estimate_shipping_cost
    if params[:zipcode] =~ /^\d{5}$/ || Spree::AdvancedCart::Config[:skip_zipcode_validation]
      @order = current_order
      @order.ship_address = Address.new(:zipcode => params[:zipcode], :country_id => Spree::Config[:default_country_id])
      @shipping_methods = ShippingMethod.all_available(@order)    
      @esc_values = @shipping_methods.map {|sm| [sm.name, sm.calculator.compute(@order)]}
    else
      flash[:error] = I18n.t(:estimation_works_only_with_us_zipcodes)
    end
  end
  
end

