class ProjectsController < ApplicationController
  def index
    @projects = Project.active.in_order
  end

  def show
    @project = Project.active.find params[:id]
    @backlog_cards = @project.cards.backlog
  end
end
