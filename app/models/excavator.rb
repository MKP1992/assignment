class Excavator < ApplicationRecord
  validates :address, :company_name, :crew_onsite, presence: true
  
  belongs_to :ticket
end
