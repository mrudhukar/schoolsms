class StudentYear < ApplicationRecord
  module ClassRooms
    ALL = ["Nursery", "LKG", "UKG", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    SECTIONS = ["A", "B", "C", "D"]
    BRANCHES = ["Main", "Second"]
  end

  belongs_to :student, inverse_of: :student_years, touch: true

  validates :student, presence: true
  validates :academic_year, presence: true, inclusion: { in: 2014..Date.today.year }, 
    format: {with: /(19|20)\d{2}/i, message: "should be a four-digit year"},
    uniqueness: { scope: :student_id}

  validates :classroom, presence: true, inclusion: {in: ClassRooms::ALL, message: "%{value} is not a valid class"}
  validates :section, inclusion: {in: ClassRooms::SECTIONS, message: "%{value} is not a valid section"}
  validates :branch, presence: true, inclusion: {in: ClassRooms::BRANCHES, message: "%{value} is not a valid branch"}

  def self.current_year
    date = Date.today
    date.month > 4 ? date.year : date.year - 1
  end
end
