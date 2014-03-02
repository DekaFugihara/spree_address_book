# encoding: UTF-8
class Spree::AddressesController < Spree::StoreController
  helper Spree::AddressesHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Address

  def index
    redirect_to account_path
  end
  
  def show
    respond_to do |format|
      format.html { render action: "show", layout: "spree/layouts/simple" }
    end
  end

  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
    @lightbox = params[:lightbox]
    layout = @lightbox ? "spree/layouts/simple" : "spree/layouts/spree_application"
    respond_to do |format|
      format.html { render action: "edit", layout: layout }
    end
  end

  def new
    @address = Spree::Address.default
    @address.address_type = (params[:t] == 's' ? 'shipping' : 'billing')
    sp = Spree::State.find_by_name("SP")
    @address.state_id = sp.id.to_s if sp
  end

  def update
    layout = params[:lightbox] ? "spree/layouts/simple" : "spree/layouts/spree_application"
    destination = params[:lightbox].empty? ? account_path : address_path(@address)
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
        redirect_to destination, layout: layout
      else
        render :action => "edit", layout: layout
      end
    else
      new_address = @address.clone
      new_address.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
        redirect_to destination, layout: layout
      else
        render :action => "edit", layout: layout
      end
    end
  end

  def create
    @address = Spree::Address.new(params[:address])
    @address.user = spree_current_user
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
  
  def retrieve_address
    @zipcode_field = params[:zipcode_field]
    
    begin
      response = open("http://www.buscarcep.com.br/?formato=xml&chave=#{ENV['BUSCARCEP_KEY']}&cep=#{params[:zipcode]}").read
      xml = Nokogiri::XML(response)
      @resultado = xml.css("resultado").text
    rescue Exception => e
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
      xml = nil
      @resultado = "-10"
    end
    
    if @resultado == "1"
      @ibge_city_code = xml.css("ibge_municipio_verificador").text
      @ibge_state_code = xml.css("ibge_uf").text
      @state_id = Spree::State.find_by_abbr(xml.css("uf").text).id
      @city = xml.css("cidade").text.html_safe
      @district = xml.css("bairro").text.html_safe
      @street = "#{xml.css('tipo_logradouro').text} #{xml.css('logradouro').text}".html_safe
    else
      resultado_txt = xml.nil? ? "webservice temporariamente indisponível" : xml.css("resultado_txt").text
      logger.error("BUSCARCEP RESPONSE: #{ @resultado } (#{resultado_txt})")
    end

    respond_to do |format|
      format.js { render "retrieve_address" }
    end
  end
  
end
