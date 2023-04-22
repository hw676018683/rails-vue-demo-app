class Api::CalendarsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    date = Date.parse(params[:date])

    @meetings_map = Meeting.where("start_at > ? and start_at < ? and status = 0", date, date+1)
      .order("start_at asc")
      .group_by(&:start_at)
    @partners = Partner.all
    @candidates_map = Candidate.all.index_by(&:id)
  end

  def create
    unless Partner.find_by(id: params[:partner_id])
      render json: { errors: "invalid partner_id" }, status: :unprocessable_entity
      return
    end
    unless Candidate.find_by(id: params[:candidate_id])
      render json: { errors: "invalid candidate_id" }, status: :unprocessable_entity
      return
    end

    candidate = Meeting.new(
      partner_id: params[:partner_id],
      start_at: params[:start_at],
      status: 0,
      candidate_id: params[:candidate_id],
    )

    if candidate.save
      render json: { id: candidate.id }, status: 201
      ChatChannel.notify(candidate)
    else
      render json: { errors: candidate.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
