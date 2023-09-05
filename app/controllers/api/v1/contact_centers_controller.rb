# frozen_string_literal: true
module Api
  module V1
    class ContactCentersController < ApplicationController
      before_action :check_address_data, only: :create

      def create
        result = CreateTicketService.new(ticket_data).call
        if result[:success]
          render json: { message: "Ticket created successfully" }, status: :created
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      private
      def ticket_data
        @ticket_data ||= contact_centers_params.to_h.deep_transform_keys!(&:underscore)
      end

      def check_address_data
        excavator_hash = ticket_data['excavator']

        errors = []
        errors << 'Address is required' if excavator_hash[:address].blank?
        errors << 'City key is required' if excavator_hash[:city].blank?
        errors << 'State key is required' if excavator_hash[:state].blank?
        errors << 'Zip key is required' if excavator_hash[:zip].blank?

        return if errors.empty?

        render json: { errors: errors }, status: :unprocessable_entity
      end

      def contact_centers_params
        params.permit(
          :RequestNumber,
          :SequenceNumber,
          :RequestType,
          :RequestAction,
          DateTimes: :ResponseDueDateTime,
          ServiceArea: [
            PrimaryServiceAreaCode: :SACode,
            AdditionalServiceAreaCodes: { SACode: [] }
          ],
          ExcavationInfo: [ DigsiteInfo: :WellKnownText ],
          Excavator: %i[CompanyName Address City State Zip CrewOnsite]
        )
      end
    end
  end
end