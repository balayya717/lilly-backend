class DailyLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Date
  field :planned_task, type: String
  field :completed, type: Boolean   # true / false / nil (not answered yet)
  field :notes, type: String
  field :source, type: String, default: "web" # web today; whatsapp later

  validates :date, presence: true
  validates :planned_task, presence: true

  index({ date: 1 }, { unique: true })
end
