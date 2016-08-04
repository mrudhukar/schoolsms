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
end
