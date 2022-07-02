class Cat < ApplicationRecord
    validates :name, :age, :enjoys, :image, presence: true
    validates :name, length: {minimum: 1}
    validates :age, length: {minimum: 1}
    validates :enjoys, length: {minimum: 10}
  end