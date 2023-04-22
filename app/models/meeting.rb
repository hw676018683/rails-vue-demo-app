class Meeting < ApplicationRecord
  validates :start_at, presence: true
  validates :status, presence: true

  validates :candidate_id, presence: true, uniqueness: { scope: [:start_at, :status] }, on: :create
  validates :partner_id, presence: true, uniqueness: { scope: [:candidate_id, :start_at] }, on: :create

  validate :validate_start_at, on: :create
  validate :ensure_only_same_one_meeting_one_day, on: :create

  def cancel!
    update(status: 1)
  end

  private

  def validate_start_at
    t = Time.now.to_date

    unless (t..(t+8)).include?(start_at.to_date) &&
      (start_at.hour >= 9 && start_at.hour < 17) &&
      ([0, 15, 30, 45]).include?(start_at.min)
      errors.add(:base, '超出范围')
    end

    schedule = Schedule.where("partner_id = ? and date = ?", partner_id, start_at.to_date).first
    unless schedule.try(:avaiable?, start_at)
      errors.add(:base, '合伙人没时间')
    end
  end

  def ensure_only_same_one_meeting_one_day
    t = start_at.to_date
    meeting = self.class.where("partner_id = ? and candidate_id = ? and status = 0 and start_at >= ? and start_at < ?", partner_id, candidate_id, t, t+1).first
    if meeting
      errors.add(:base, '同⼀个创业者和同⼀个合伙⼈⼀天内只能最多⼀次会⾯。')
    end
  end
end
