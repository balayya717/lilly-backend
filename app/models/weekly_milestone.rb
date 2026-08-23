class WeeklyMilestone
  include Mongoid::Document
  include Mongoid::Timestamps

  field :week_number, type: Integer
  field :target_description, type: String
  field :status, type: String, default: "pending" # pending | done — derived from percent_complete
  field :percent_complete, type: Integer, default: 0
  field :notes, type: String

  belongs_to :monthly_goal

  validates :week_number, presence: true
  validates :target_description, presence: true
  validates :status, inclusion: { in: %w[pending done] }
  validates :percent_complete, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  }

  before_validation :sync_status_from_percent

  private

  def sync_status_from_percent
    self.status = percent_complete.to_i >= 100 ? "done" : "pending"
  end
end
