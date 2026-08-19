class MonthlyGoalsController < ApplicationController
  def index
    render json: MonthlyGoal.all.order_by(created_at: :desc)
  end

  def show
    render json: MonthlyGoal.find(params[:id])
  end

  def create
    goal = MonthlyGoal.new(goal_params)
    goal.save!
    render json: goal, status: :created
  end

  def update
    goal = MonthlyGoal.find(params[:id])
    goal.update!(goal_params)
    render json: goal
  end

  def destroy
    MonthlyGoal.find(params[:id]).destroy
    head :no_content
  end

  private

  def goal_params
    params.require(:monthly_goal).permit(:month, :title, :description, :status)
  end
end
