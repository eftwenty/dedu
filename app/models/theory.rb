class Theory < ApplicationRecord
  belongs_to :course
  has_attached_file :document

  validates_presence_of :title, :content
  do_not_validate_attachment_file_type :document
end
