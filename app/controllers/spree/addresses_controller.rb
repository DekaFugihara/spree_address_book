# encoding: UTF-8
class Spree::AddressesController < Spree::StoreController
  helper Spree::AddressesHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Address

  def index
    redirect_to account_path
  end
  
  def show
    redirect_to account_path
  end

  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def new
    @address = Spree::Address.default
    @address.address_type = (params[:t] == 's' ? 'shipping' : 'billing')
    sp = Spree::State.find_by_name("SP")
    @address.state_id = sp.id.to_s if sp
  end

  def update
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
        redirect_back_or_default(account_path)
      else
        render :action => "edit"
      end
    else
      new_address = @address.clone
      new_address.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
        redirect_back_or_default(account_path)
      else
        render :action => "edit"
      end
    end
  end

  def create
    @address = Spree::Address.new(params[:address])
    @address.user = current_user
    if @address.save
      flash[:notice] = I18n.t(:successfully_created, :resource => I18n.t(:address))
      redirect_to account_path
    else
      render :action => "new"
    end
  end

  def destroy
    @address.destroy

    flash[:notice] = I18n.t(:successfully_removed, :resource => t(:address))
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
