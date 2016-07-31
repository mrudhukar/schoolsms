class Student < ApplicationRecord
  module Status
    ACTIVE = 0
    INACTIVE = 1
  end

  has_many :parents, dependent: :destroy
  has_many :class_students, dependent: :destroy

  validates :first_name, presence: true, allow_blank: false, 
    format: { with: /\A[a-zA-Z]/, message: "Cannot Start with Numbers or symbols" }, 
    uniqueness: { scope: [:last_name , :middle_name, :date_of_birth], message: "is already in the system" }

  validates :gender, presence: true, allow_blank: false, inclusion: {in: %w(Male Female), message: "%{value} is not a valid gender"}
  validates :date_of_birth, presence: true

  scope :current, -> {where(status: Status::ACTIVE)}
  scope :old, -> {where(status: Status::INACTIVE)}

  def current_class_student
    self.class_students.where(year: ClassStudent.current_year).first
  end
end