class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = { super: 0, teacher: 1, student: 2 }

  enum role: ROLES

  belongs_to :group, optional: true

  validates_presence_of :group_id, if: -> { student? }
end
