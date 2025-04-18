require "rails_helper"

RSpec.describe "Cards", type: :request do
  include Login

  let(:user) { Fabrik.db.users.create }
  let(:project) { Fabrik.db.projects.create }
  let(:valid_attributes) { {title: "New Card", complexity: "simple", status: "backlog"} }
  let(:invalid_attributes) { {title: "", complexity: "simple", status: "backlog"} }

  before do
    login_as user
  end

  describe "GET /projects/:project_id/cards/new" do
    it "renders the new card form" do
      get new_project_card_path(project)
      expect(response).to have_http_status(200)
      expect(response.body).to include("New Card for")
    end
  end

  describe "POST /projects/:project_id/cards" do
    context "with valid parameters" do
      it "creates a new card and redirects to the project" do
        expect {
          post project_cards_path(project), params: {card: valid_attributes}
        }.to change(Card, :count).by(1)

        expect(response).to redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("New Card")
      end
    end

    context "with invalid parameters" do
      it "does not create a new card and renders the form again" do
        expect {
          post project_cards_path(project), params: {card: invalid_attributes}
        }.not_to change(Card, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
      end
    end
  end
end
