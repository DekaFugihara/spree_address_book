# coding: utf-8
Spree::Address.class_eval do
  belongs_to :user, :class_name => Spree.user_class.to_s
  
  usar_como_cpf :cpf
  validates :address_number, :address_district, :phone_ddd, :zipcode, :presence => true
  validates_presence_of :cpf, :unless => Proc.new { |address| address.address_type == "shipping" }
  validates_length_of :address2, :maximum => 40
  validates_length_of :address1, :maximum => 80
  validates_length_of :address_district, :maximum => 60
  validates_length_of :city, :in => 2..60
  validates_length_of :address_number, :maximum => 20
  validates_numericality_of :phone_ddd, :zipcode

  attr_accessible :user_id, :deleted_at, :address_type, :address_number, :address_district, :phone_ddd, :cpf

  def self.required_fields
    validator = Spree::Address.validators.find_all{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator ? validator.collect(&:attributes).flatten : []
  end
  
  # TODO: look into if this is actually needed. I don't want to override methods unless it is really needed
  # can modify an address if it's not been used in an order
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') == other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end
  
  # can modify an address if it's not been used in an completed order
  def editable?
    new_record? || (shipments.empty? && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    [
      "#{firstname} #{lastname}",
      "#{address1}, #{address_number}",
      "#{address2}",
      "#{city} / #{state || state_name}",
      "CEP: #{zipcode}"
    ].reject(&:empty?).join("<br/>").html_safe
  end

  # UPGRADE_CHECK if future versions of spree have a custom destroy function, this will break
  def destroy
    if can_be_deleted?
      super
    else
      update_column :deleted_at, Time.now
    end
  end
end
