module BasicParams
  extend ActiveSupport::Concern

  def excavator_params
    {
      company_name: ticket_data.dig('excavator', 'company_name'),
      crew_onsite: ticket_data.dig('excavator', 'crew_onsite'),
      address: excavator_address_format(ticket_data['excavator'])
    }
  end

  def excavator_address_format(data)
    [data['address'], data['city'], data['state'], data['zip']].compact.join(', ')
  end


  def service_area_params
    {
      primary_sa_code: ticket_data.dig('service_area', 'primary_service_area_code', 'sa_code'),
      additional_sa_codes: ticket_data.dig('service_area', 'additional_service_area_codes', 'sa_code'),
    }
  end

  def ticket_params
    {
      request_number: ticket_data['request_number'],
      sequence_number: ticket_data['sequence_number'],
      request_type: ticket_data['request_type'],
      request_action: ticket_data['request_action'],
      response_due_date_time: ticket_data.dig('date_times', 'response_due_date_time')&.to_datetime,
      well_known_text: ticket_data.dig('excavation_info', 'digsite_info', 'well_known_text')
    }
  end
end