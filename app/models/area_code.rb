class AreaCode < ApplicationRecord
	validates :sa_code, presence: true, uniqueness: true
end
