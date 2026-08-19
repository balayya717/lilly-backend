class WeeklyMilestone
  include Mongoid::Document
  include Mongoid::Timestamps

  field :week_number, type: Integer
  field :target_description, type: String
  field :status, type: String, default: "pending" # pending | done

  belongs_to :monthly_goal

  validates :week_number, presence: true
  validates :target_description, presence: true
  validates :status, inclusion: { in: %w[pending done] }
end
