class MonthlyGoal
  include Mongoid::Document
  include Mongoid::Timestamps

  field :month, type: String        # e.g. "2026-09"
  field :title, type: String        # e.g. "Finish Polity Ch 1-10"
  field :description, type: String
  field :status, type: String, default: "active" # active | completed

  has_many :weekly_milestones, dependent: :destroy
  accepts_nested_attributes_for :weekly_milestones

  validates :month, presence: true
  validates :title, presence: true
  validates :status, inclusion: { in: %w[active completed] }
  validate :must_have_four_weekly_milestones, on: :create

  index({ month: 1 })

  def percent_complete
    milestones = weekly_milestones.to_a
    return 0 if milestones.empty?
    (milestones.sum { |m| m.percent_complete.to_i } / milestones.size.to_f).round
  end

  def as_json(options = {})
    super(options).merge(
      "percent_complete" => percent_complete,
      "weekly_milestones" => weekly_milestones.order_by(week_number: :asc).as_json
    )
  end

  private

  def must_have_four_weekly_milestones
    active_milestones = weekly_milestones.reject(&:marked_for_destruction?)
    return if active_milestones.size == 4

    errors.add(:weekly_milestones, "must include exactly 4 weekly milestones")
  end
end
