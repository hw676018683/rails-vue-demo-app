class Api::CalendarsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :find_meeting, only: [:cancel]

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
      render json: { errors: "invalid partner_id" }, status: 422
      return
    end
    unless Candidate.find_by(id: params[:candidate_id])
      render json: { errors: "invalid candidate_id" }, status: 422
      return
    end

    meeting = Meeting.new(
      partner_id: params[:partner_id],
      start_at: params[:start_at],
      status: 0,
      candidate_id: params[:candidate_id],
    )

    if meeting.save
      render json: { id: meeting.id }, status: 201
      ChatChannel.notify(meeting.id)
    else
      render json: { errors: meeting.errors.full_messages }, status: 422
    end
  end

  def cancel
    @meeting.cancel!
    ChatChannel.notify(@meeting.id)
    head 204
  end

  private

  def find_meeting
    unless @meeting = Meeting.find_by(id: params[:id])
      render json: { errors: "invalid meeting id" }, status: 404
    end
  end
end
