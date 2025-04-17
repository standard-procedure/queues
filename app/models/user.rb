class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :first_name, with: ->(n) { n.strip }
  normalizes :last_name, with: ->(n) { n.strip }

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s.]+\z/
  validates :email_address, presence: true, format: {with: EMAIL_REGEX}

  has_many :projects, inverse_of: :owner
end
