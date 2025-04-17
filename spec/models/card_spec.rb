require "rails_helper"

RSpec.describe Card, type: :model do
  describe "validations" do
    it "requires a title" do
      card = Card.new(title: nil)
      expect(card).not_to be_valid
      expect(card.errors[:title]).to include("can't be blank")
    end

    it "normalizes title" do
      card = Card.new(title: " Test Card ")
      card.valid?
      expect(card.title).to eq("Test Card")
    end
  end

  describe "associations" do
    it "belongs to a project" do
      association = Card.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "scopes" do
    it "defines an active scope" do
      expect(Card).to respond_to(:active)

      # Test that the scope exists without testing implementation details
      expect(Card.active).to be_an(ActiveRecord::Relation)
    end
  end

  describe "enums" do
    it "defines status enum with correct values" do
      expected_statuses = {
        "backlog" => 0,
        "in_progress" => 10,
        "in_qa" => 20,
        "ready_to_deploy" => 30,
        "completed" => 100,
        "cancelled" => -1
      }
      expect(Card.statuses).to eq(expected_statuses)
    end

    it "defines complexity enum with correct values" do
      expected_complexity = {
        "trivial" => 1,
        "simple" => 2,
        "complex" => 4,
        "requires_breakdown" => 8
      }
      expect(Card.complexities).to eq(expected_complexity)
    end
  end

  describe "positioning" do
    let(:project) { Project.create!(name: "Test Project", velocity: 5, owner: User.create!(email_address: "test@example.com", password: "password", first_name: "Test", last_name: "User")) }

    it "automatically assigns position when created" do
      card = project.cards.create!(title: "First Card")
      expect(card.position).to eq(1)

      second_card = project.cards.create!(title: "Second Card")
      expect(second_card.position).to eq(2)
    end

    it "maintains order when retrieving cards" do
      # Create cards in a different order
      project.cards.create!(title: "Card 3", position: 3)
      project.cards.create!(title: "Card 1", position: 1)
      project.cards.create!(title: "Card 2", position: 2)

      # Retrieve cards and check order
      ordered_cards = project.cards.to_a
      expect(ordered_cards.map(&:title)).to eq(["Card 1", "Card 2", "Card 3"])
    end
  end
end
