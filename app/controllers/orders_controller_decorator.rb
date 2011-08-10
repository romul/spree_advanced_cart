OrdersController.class_eval do
  require 'zip-code-info'
  
  def update
    @order = current_order(true)
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
    @order = current_order(true)
    address = if params[:zipcode] =~ /^\d{5}$/ and state = state_id_by_zip(params[:zipcode]) || Spree::AdvancedCart::Config[:skip_zipcode_validation]
      Address.new(:zipcode => params[:zipcode],
              :country_id => Spree::Config[:default_country_id],
              :state_id => state.id)
    elsif params[:zipcode] =~ /[:alpha:][\d][:alpha:]\s?[\d][:alpha:][\d]/
      Address.new(:zipcode => params[:zipcode],
              :country_id => Country.find_by_iso('CA').id)
    end
    if address
      @order.ship_address = address
      @shipping_methods = ShippingMethod.all_available(@order)    
      @esc_values = @shipping_methods.map {|sm| [sm.name, sm.calculator.compute(@order)]}
      respond_with do |format|
        format.html { flash[:notice] = @esc_values.collect{|name, price| "#{name} #{price}" }.join("<br />").html_safe; redirect_to cart_path }
        format.js { render :action => :estimate_shipping_cost }
      end
    else
      flash[:error] = I18n.t('estimation_requires_supported_zipcode')
    end
  end
  
  def state_id_by_zip(zip_code)
    State.find_by_abbr(ZipCodeInfo.instance.state_for(zip_code))
  end
  
end

