require "rails_helper"

RSpec.describe "Projects", type: :request do
  include Login

  describe "GET /projects" do
    it "redirects to the login page if not logged in" do
      get projects_path

      expect(response).to redirect_to(new_session_path)
    end

    it "shows the projects page if logged in" do
      @user = Fabrik.db.users.create
      @project = Fabrik.db.projects.create
      login_as @user

      get projects_path

      expect(response).to have_http_status(200)
      expect(response.body).to include @project.to_s
    end
  end

  describe "GET /projects/:id" do
    it "redirects to the login page if not logged in" do
      @project = Fabrik.db.projects.create

      get project_path(@project)

      expect(response).to redirect_to(new_session_path)
    end

    it "shows the projects page if logged in and the project is active" do
      @project = Fabrik.db.projects.create
      @user = Fabrik.db.users.create
      login_as @user

      get project_path(@project)

      expect(response).to have_http_status(200)
      expect(response.body).to include CGI.escape_html(@project.to_s)
    end

    it "shows a 404 if logged in and the project is not active" do
      @project = Fabrik.db.projects.create status: "inactive"
      @user = Fabrik.db.users.create
      login_as @user

      get project_path(@project)

      expect(response).to have_http_status(404)
    end
  end
end
