class Attendance < ApplicationRecord
  module AbsentType
    FULLDAY = 0
    MORNING = 1
    EVENING = 2
    ALL = [FULLDAY, MORNING, EVENING]
  end

  belongs_to :student_year

  validates :student_year, presence: true
  validates :absent_type, presence: true, inclusion: {in: AbsentType::ALL, message: "%{value} is not a valid type"}
  validates :absent_on, presence: true, uniqueness: { scope: :student_year, message: "is already marked absent" }

end
