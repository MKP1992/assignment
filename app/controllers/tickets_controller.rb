class TicketsController < ApplicationController
  DEFAULT_LIMIT = 15

  def index
    @tickets = Ticket.with_full_info.page(params[:page]).per(DEFAULT_LIMIT)
  end

  def show
    @ticket = Ticket.find(params[:id])
  end
end