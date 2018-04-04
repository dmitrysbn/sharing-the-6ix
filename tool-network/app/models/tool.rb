class Tool < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: 'user_id'
  has_many :borrowers, through: :reviews, source: :user
  has_many :reviews

  has_many :loans
  has_many :owner_images
  
end
