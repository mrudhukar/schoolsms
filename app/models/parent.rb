class Parent < ApplicationRecord
  module RelationShip
    FATHER = "Father"
    MOTHER = "Mother"
    GAURDIAN = "Gaurdian"
    ALL = [FATHER, MOTHER, GAURDIAN]
  end

  belongs_to :student, inverse_of: :parents

  validates :student, presence: true
  validates :name, presence: true, allow_blank: false, 
    format: { with: /\A[a-zA-Z]/, message: "Cannot Start with Numbers or symbols" }, 
    uniqueness: { scope: [:student_id, :phone], message: "is already in the system" }

  validates :relation, presence: true, allow_blank: false, 
    inclusion: {in: RelationShip::ALL, message: "%{value} is not a valid gender"}, 
    uniqueness: { scope: [:student_id, :phone], message: "is already in the system" }

  validates :phone, allow_blank: true, length: {is: 10}, numericality: {greater_than: 0}

  scope :with_branch, ->(branch) { joins(student: :student_years).where("student_years.branch = ?", branch) }
  scope :with_klass, ->(klass) { joins(student: :student_years).where("student_years.classroom = ?", klass) }
  scope :with_medium, ->(medium) { joins(student: :student_years).where("student_years.medium = ?", medium) }
  scope :with_relation, ->(relation) { where("parents.relation = ?", relation) }
  scope :with_academic_year, ->(year) { joins(student: :student_years).where("student_years.academic_year = ?", year) }
  scope :with_number, ->(status) { where("parents.phone IS NOT NULL") }
  

  filterrific(
    available_filters: [
      :with_branch,
      :with_medium,
      :with_klass,
      :with_relation,
      :with_academic_year,
      :with_number
    ]
  )
end
