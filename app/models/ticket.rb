class Ticket < ApplicationRecord
	has_one :excavator
	has_one :primary_service_area, class_name: 'ServiceArea::Primary'
	has_many :additional_service_areas, class_name: 'ServiceArea::Additional'

	scope :with_full_info, lambda {
		includes(
			:excavator,
			primary_service_area: :area_code,
			additional_service_areas: :area_code
		)
	}

  validates :request_number, presence: true, uniqueness: true
	validates :sequence_number, :well_known_text, :response_due_date_time, presence: true

	delegate :company_name, :address, :crew_onsite, to: :excavator, allow_nil: true

	def polygon
    well_known_text.scan(/[+-]?\d+.\d+/).map(&:to_f).each_slice(2).to_a
  end

  def primary_sa_code
    return 'None' unless self.primary_service_area.present?

    self.primary_service_area.area_code.sa_code
  end

  def additional_sa_codes
    additional_sa = additional_service_areas.map(&:area_code).map(&:sa_code)
    return additional_sa.compact.flatten.join(', ') if additional_sa
  	'None'
  end

  def crew_on_site_status
    self.crew_onsite ? 'Yes' : 'No'
  end
end
