class Schedule < ApplicationRecord
  def avaiable?(start_at)
    JSON.parse(times).include? start_at.strftime("%H:%M")
  end
end
