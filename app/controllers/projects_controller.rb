class ProjectsController < ApplicationController
  def index
    @projects = Project.active.in_order
  end
end
