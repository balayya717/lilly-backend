class WeeklyMilestonesController < ApplicationController
  before_action :set_goal

  def index
    render json: @goal.weekly_milestones.order_by(week_number: :asc)
  end

  def create
    milestone = @goal.weekly_milestones.new(milestone_params)
    milestone.save!
    render json: milestone, status: :created
  end

  def update
    milestone = @goal.weekly_milestones.find(params[:id])
    milestone.update!(milestone_params)
    render json: milestone
  end

  def destroy
    @goal.weekly_milestones.find(params[:id]).destroy
    head :no_content
  end

  private

  def set_goal
    @goal = MonthlyGoal.find(params[:monthly_goal_id])
  end

  def milestone_params
    params.require(:weekly_milestone).permit(
      :week_number, :target_description, :status, :percent_complete, :notes
    )
  end
end
