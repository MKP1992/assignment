#STI used to make service area as per primary/additional
class ServiceArea < ApplicationRecord
  belongs_to :ticket
  belongs_to :area_code
end