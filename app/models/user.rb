class User < ApplicationRecord
  has_secure_password
  has_many :productivity_sessions
end
