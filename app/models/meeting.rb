class Meeting < ApplicationRecord
  validates :start_at, presence: true
  validate :validate_start_at
  validates :status, presence: true

  validates :candidate_id, presence: true, uniqueness: { scope: [:start_at, :status] }, on: :create
  validates :partner_id, presence: true, uniqueness: { scope: [:start_at, :status] }, on: :create

  def validate_start_at
    t = Time.now.to_date

    if (t..(t+8)).include?(start_at.to_date) &&
      (start_at.hour >= 9 && start_at.hour < 17) &&
      ([0, 15, 30, 45]).include?(start_at.min)
      return
    end

    errors.add(:start_at, 'invalid')
  end
end
