require "rails_helper"

RSpec.describe User, type: :model do
  describe "normalization" do
    it "normalizes email address" do
      user = User.new(email_address: " Test@EXAMPLE.com ")
      user.valid?
      expect(user.email_address).to eq("test@example.com")
    end

    it "normalizes first name" do
      user = User.new(first_name: " John ")
      user.valid?
      expect(user.first_name).to eq("John")
    end

    it "normalizes last name" do
      user = User.new(last_name: " Doe ")
      user.valid?
      expect(user.last_name).to eq("Doe")
    end
  end

  describe "validations" do
    it "requires an email address" do
      user = User.new(email_address: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it "requires a valid email format" do
      valid_emails = [
        "user@example.com",
        "user.name@example.com",
        "user+tag@example.com",
        "user@sub.example.com"
      ]

      invalid_emails = [
        "user",
        "user@",
        "@example.com",
        "user@.com",
        "user@example."
      ]

      valid_emails.each do |email|
        user = User.new(email_address: email, password: "password")
        expect(user).to be_valid, "Expected #{email} to be valid"
      end

      invalid_emails.each do |email|
        user = User.new(email_address: email, password: "password")
        expect(user).not_to be_valid, "Expected #{email} to be invalid"
        expect(user.errors[:email_address]).to include("is invalid")
      end
    end
  end

  describe "associations" do
    it "has many sessions with dependent destroy" do
      association = User.reflect_on_association(:sessions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "has many projects" do
      association = User.reflect_on_association(:projects)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "authentication" do
    it "has secure password" do
      expect(User.instance_methods).to include(:authenticate)
      expect(User.instance_methods).to include(:password=)
    end
  end
end
