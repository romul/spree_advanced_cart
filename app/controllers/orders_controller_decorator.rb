Spree::OrdersController.class_eval do
  require 'zip-code-info'
  
  def update
    @order = current_order
    if @order.update_attributes(params[:order])
      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      
      if @order.coupon_code.present?
        promo = Spree::Promotion.where(:code => @order.coupon_code).first
        if promo
          if promo.eligible?(@order) && promo.order_activatable?(@order)
            fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
          else
            flash.now[:error] = I18n.t(:promotion_cant_be_applied_to_current_order, :code => promo.code)
          end
        else
          flash.now[:error] = I18n.t(:promotion_not_found)
        end
      end
      
      respond_with(@order) do |format| 
        format.html { redirect_to cart_path }
        format.js { @order.update!; render }
      end
    else
      respond_with(@order)
    end
  end
  
  def estimate_shipping_cost
    @order = current_order(true)
    # default attributes for stub address
    country_id = params[:country_id] || Spree::Config[:default_country_id]
    address_attrs = { :zipcode => params[:zipcode], 
                      :country_id => country_id }
    
    country = Spree::Country.find(country_id)
    if country.iso == 'US'
      state = state_id_by_zip(params[:zipcode])
      address_attrs.merge!(:state_id => state.try(:id))
    end

    @order.ship_address = Spree::Address.new(address_attrs)
    @shipping_methods = Spree::ShippingMethod.all_available(@order)    
    @esc_values = @shipping_methods.map do |sm|
        error = nil
        begin
          rate = sm.calculator.compute(@order) 
        rescue Spree::ShippingError => ex
          error = ex.message.sub("Shipping Error: ", '')
        rescue Net::HTTPServiceUnavailable
          error = nil # carrier is unavailable atm, don't show this shipping method in the list
        end
        [sm.name, rate, error]
      end.select{|sm| sm[1] || sm[2]}. # a shipping calculator can return nil for the price if error occurred
          sort_by{|sm| sm[1] ? sm[1] : Float::MAX} # mimic default spree_core behavior, preserve asc cost order
    
    respond_with do |format|
      format.html do
        flash[:notice] = @esc_values.collect{|name, price| "#{name} #{price}" }.join("<br />").html_safe if @esc_values.present?
        redirect_to cart_path
      end
      format.js do
        render :action => :estimate_shipping_cost
      end
    end
  end
  
  def state_id_by_zip(zip_code)
    Spree::State.find_by_abbr(ZipCodeInfo.instance.state_for(zip_code))
  end
  
end
