class Project < ApplicationRecord
  belongs_to :owner, class_name: "User"
  validates :name, presence: true
  normalizes :name, with: ->(n) { n.strip }
  enum :status, active: 0, inactive: -1
  has_rich_text :description
end
