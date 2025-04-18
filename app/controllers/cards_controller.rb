class CardsController < ApplicationController
  before_action :set_project

  def new
    @card = @project.cards.new
  end

  def create
    @card = @project.cards.new(card_params)

    if @card.save
      redirect_to @project, notice: "Card was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.active.find(params[:project_id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :complexity, :status)
  end
end
