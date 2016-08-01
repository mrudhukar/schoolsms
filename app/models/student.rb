class Student < ApplicationRecord
  module Status
    ACTIVE = 0
    INACTIVE = 1
  end

  has_many :parents, dependent: :destroy, inverse_of: :student
  has_many :student_years, -> {order("student_years.academic_year DESC, student_years.id DESC")}, dependent: :destroy, inverse_of: :student

  validates :first_name, presence: true, allow_blank: false, 
    format: { with: /\A[a-zA-Z]/, message: "Cannot Start with Numbers or symbols" }, 
    uniqueness: { scope: [:last_name , :middle_name, :date_of_birth], message: "is already in the system" }

  validates :gender, presence: true, allow_blank: false, inclusion: {in: %w(Male Female), message: "%{value} is not a valid gender"}
  validates :date_of_birth, presence: true

  validates :phone, allow_blank: true, length: {is: 10}, numericality: {greater_than: 0}

  scope :current, -> {where(status: Status::ACTIVE)}
  scope :old, -> {where(status: Status::INACTIVE)}

  accepts_nested_attributes_for :student_years, :reject_if => :all_blank
  accepts_nested_attributes_for :parents, :reject_if => :all_blank, :allow_destroy => true
  validates_associated :student_years
  validates_associated :parents


  def current_student_year
    self.student_years.first
  end

  def name
    name = self.first_name
    name << " #{self.middle_name}" if self.middle_name.present?
    name << " #{self.last_name}" if self.last_name.present?

    name
  end
end