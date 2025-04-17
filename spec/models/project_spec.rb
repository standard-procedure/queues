require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it "requires a name" do
      project = Project.new(name: nil)
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end

    it "requires a positive integer velocity" do
      project = Project.new(velocity: nil)
      expect(project).not_to be_valid
      expect(project.errors[:velocity]).to include("can't be blank")

      project.velocity = "string"
      expect(project).not_to be_valid
      expect(project.errors[:velocity]).to include("is not a number")

      project.velocity = 0
      expect(project).not_to be_valid
      expect(project.errors[:velocity]).to include("must be greater than 0")

      # Note: This test will still fail until we set all required attributes
      # since other validations will prevent velocity errors from being cleared
    end

    it "normalizes name" do
      project = Project.new(name: " Test Project ")
      project.valid?
      expect(project.name).to eq("Test Project")
    end
  end

  describe "associations" do
    it "belongs to an owner" do
      association = Project.reflect_on_association(:owner)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq("User")
    end

    it "has many cards" do
      association = Project.reflect_on_association(:cards)
      expect(association.macro).to eq(:has_many)
    end

    it "has many all_cards with dependent destroy" do
      association = Project.reflect_on_association(:all_cards)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "scopes" do
    it "orders projects by name with in_order scope" do
      expect(Project.in_order.to_sql).to include("ORDER BY")
    end
  end

  describe "enums" do
    it "defines status enum with correct values" do
      expect(Project.statuses).to include("active" => 0, "inactive" => -1)
    end
  end

  describe "instance methods" do
    it "returns name for to_s" do
      project = Project.new(name: "Test Project")
      expect(project.to_s).to eq("Test Project")
    end

    it "returns parameterized id and name for to_param" do
      project = Project.new(id: 1, name: "Test Project")
      expect(project.to_param).to eq("1-test-project")
    end
  end
end
