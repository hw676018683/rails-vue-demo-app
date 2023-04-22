class Api::CalendarsController < ApplicationController
  def index
    date = Date.parse(params[:date])

    @meetings_map = Meeting.where("start_at > ? and start_at < ? and status = 0", date, date+1).group_by(&:start_at)
    @partners = Partner.all
    @candidates_map = Candidate.all.index_by(&:id)
  end
end
