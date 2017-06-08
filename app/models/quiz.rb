class Quiz < ApplicationRecord
  belongs_to :course
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :by_course_created_by, -> (id) { joins(:course).where(courses: {created_by: id}) }

  validates_presence_of :title, :course
end
