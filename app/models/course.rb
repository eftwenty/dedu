class Course < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :theories, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_one :quiz

  accepts_nested_attributes_for :theories, allow_destroy: true
  accepts_nested_attributes_for :practices, allow_destroy: true

  validates_presence_of :title, :description
  validates_uniqueness_of :title
end
