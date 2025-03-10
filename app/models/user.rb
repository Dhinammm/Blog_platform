class User < ApplicationRecord
  has_many :articles
  validates :name, :email, :password, presence: true 
end
