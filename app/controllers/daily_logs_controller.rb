class DailyLogsController < ApplicationController
  def index
    logs = DailyLog.all.order_by(date: :desc)
    logs = logs.where(date: Date.parse(params[:date])) if params[:date].present?
    render json: logs
  end

  def create
    log = DailyLog.new(log_params)
    log.save!
    render json: log, status: :created
  end

  def update
    log = DailyLog.find(params[:id])
    log.update!(log_params)
    render json: log
  end

  private

  def log_params
    params.require(:daily_log).permit(:date, :planned_task, :completed, :notes, :source)
  end
end
