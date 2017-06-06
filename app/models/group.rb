class Group < ApplicationRecord
  has_many :students, -> { student }, class_name: 'User'
  has_and_belongs_to_many :courses

  validates_presence_of :code
end
