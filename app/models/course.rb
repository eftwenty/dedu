class Course < ApplicationRecord
  has_and_belongs_to_many :groups

  validates_presence_of :title, :description
  validates_uniqueness_of :title
end
