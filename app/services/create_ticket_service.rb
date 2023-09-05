# app/services/create_ticket_service.rb
class CreateTicketService
  class SaveFailure < StandardError; end
  include BasicParams
  attr_accessor :ticket_data

  def initialize(ticket_data)
    @ticket_data = ticket_data
  end

  def call
    Ticket.transaction do
      create_ticket_and_associations
    end
  rescue SaveFailure => e
    { status: false, errors: JSON.parse(e.message) }
  end

  private

  def create_ticket_and_associations
    ticket = Ticket.new(ticket_params)
    raise SaveFailure, ticket.errors.full_messages.to_json unless ticket.save
    
    excavator = initialize_excavator(excavator_params, ticket)
    raise SaveFailure, excavator.errors.full_messages.to_json unless excavator.save

    ticket.primary_service_area = primary_service_area(service_area_params[:primary_sa_code])
    ticket.additional_service_areas = additional_service_areas(service_area_params[:additional_sa_codes])
    { success: true, ticket: ticket } 
  end

  private

  def initialize_excavator(data, ticket)
    Excavator.new(
      ticket: ticket,
      company_name: data[:company_name],
      address: data[:address],
      crew_onsite: data[:crew_onsite]
    )
  end

  def primary_service_area(sa_code)
    return if sa_code.blank?
    @primary_service_area ||= ServiceArea::Primary.new(
      area_code: find_code(sa_code)
    )
  end

  def additional_service_areas(sa_codes)
    return if sa_codes.nil?
    sa_codes.map do |sa|
      ServiceArea::Additional.new(area_code: find_code(sa))
    end
  end

  def find_code(sa_code = nil)
    return if sa_code.nil?
    AreaCode.find_or_create_by(sa_code: sa_code)
  end
end
