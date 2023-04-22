json.calendars @meetings_map.each do |start_at, meetings|
  json.time start_at.strftime("%H:%M")
  json.meetings meetings.each do |meeting|
    json.id meeting.id
    json.time meeting.start_at.strftime("%H:%M")
    json.partner_id  meeting.partner_id
    json.candidate_id meeting.candidate_id
    json.candidate_name @candidates_map[meeting.candidate_id].name
  end
end

json.partners @partners.each do |partner|
  json.id partner.id
  json.name partner.name
end
