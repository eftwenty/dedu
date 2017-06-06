class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = { super: 0, teacher: 1, student: 2 }

  enum role: ROLES

  belongs_to :group, optional: true
  has_many :courses, through: :group

  scope :without_group, -> { where(group_id: nil) }
  scope :without_group_or_relates_to, -> (group_id) { where('group_id IS NULL OR group_id = ?', group_id) }

  validates_presence_of :first_name, :last_name, unless: -> { super? }
  validates_presence_of :group_id, if: -> { student? }, allow_blank: true

  def pretty_name
    "#{first_name} #{last_name}"
  end
end
