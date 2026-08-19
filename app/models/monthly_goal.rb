class MonthlyGoal
  include Mongoid::Document
  include Mongoid::Timestamps

  field :month, type: String        # e.g. "2026-09"
  field :title, type: String        # e.g. "Finish Polity Ch 1-10"
  field :description, type: String
  field :status, type: String, default: "active" # active | completed

  has_many :weekly_milestones, dependent: :destroy

  validates :month, presence: true
  validates :title, presence: true
  validates :status, inclusion: { in: %w[active completed] }

  index({ month: 1 })
end
