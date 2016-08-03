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

  validates :aadhar_number, allow_blank: true, uniqueness: true
  validates :admission_number, allow_blank: true, uniqueness: true

  validates :joined_class, allow_blank: true, inclusion: {in: StudentYear::ClassRooms::ALL, message: "%{value} is not a valid class"}

  scope :current, -> {where(status: Status::ACTIVE)}
  scope :old, -> {where(status: Status::INACTIVE)}

  scope :with_branch, ->(branch) { joins(:student_years).where("student_years.branch = ?", branch) }
  scope :with_klass, ->(klass) { joins(:student_years).where("student_years.classroom = ?", klass) }
  scope :with_sections, ->(section) { joins(:student_years).where("student_years.section = ?", section) }
  scope :with_academic_year, ->(year) { joins(:student_years).where("student_years.academic_year = ?", year) }
  scope :with_status, ->(status) {where("students.status = ?", status) }
  scope :search_query, ->(query) { joins(:student_years).where("student_years.roll_number LIKE ? OR students.first_name LIKE ? OR students.last_name LIKE ?", "%#{query}%","#{query}%","#{query}%") }

  accepts_nested_attributes_for :student_years, :reject_if => :all_blank
  accepts_nested_attributes_for :parents, :reject_if => :all_blank, :allow_destroy => true
  validates_associated :student_years
  validates_associated :parents

  filterrific(
    available_filters: [
      :with_branch,
      :with_klass,
      :with_sections,
      :search_query,
      :with_status,
      :with_academic_year
        ]
    )


  def current_student_year
    self.student_years.first
  end

  def name
    fullname = self.first_name
    fullname += " #{self.last_name}" if self.last_name.present?

    fullname
  end
end