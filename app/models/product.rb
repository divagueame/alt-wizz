class Product < ApplicationRecord
  has_many :suggestions
  has_one_attached :image do |attachable|
    attachable.variant :basic, resize_to_limit: [600, 600]
  end
end
