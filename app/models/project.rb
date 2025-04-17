class Project < ApplicationRecord
  scope :in_order, -> { order :name }
  belongs_to :owner, class_name: "User"
  validates :name, presence: true
  normalizes :name, with: ->(n) { n.strip }
  enum :status, active: 0, inactive: -1
  has_rich_text :description
  has_many :cards, -> { active.order :position }
  has_many :all_cards, -> { order :position }, dependent: :destroy

  def to_s = name

  def to_param = "#{id}-#{self}".parameterize
end
