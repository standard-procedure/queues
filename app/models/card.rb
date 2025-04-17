class Card < ApplicationRecord
  scope :active, -> { where(status: %w[backlog in_progress in_qa ready_to_deploy]) }
  belongs_to :project
  validates :title, presence: true
  normalizes :title, with: ->(t) { t.strip }
  enum :status, backlog: 0, in_progress: 10, in_qa: 20, ready_to_deploy: 30, completed: 100, cancelled: -1
  has_rich_text :description
  positioned on: :project
end
