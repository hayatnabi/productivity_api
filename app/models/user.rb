class User < ApplicationRecord
  has_secure_password
  has_many :productivity_sessions

  # ✅ Ensure email is unique and present
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
