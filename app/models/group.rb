class Group < ApplicationRecord
  has_many :students, -> { student }, class_name: 'User'

  validates_presence_of :code
end
