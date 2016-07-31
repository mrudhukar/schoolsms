class ClassStudent < ApplicationRecord
  module ClassRooms
    ALL = ["Nursery", "LKG", "UKG", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
  end

  belongs_to :student

  validates :year, presence: true, inclusion: { in: 2014..Date.today.year }, 
    format: { 
      with: /(19|20)\d{2}/i, 
      message: "should be a four-digit year"
    }

  validates :class, presence: true, inclusion: {in: ClassRooms::ALL, message: "%{value} is not a valid class"}
  validates :section, inclusion: {in: ["A", "B", "C", "D"], message: "%{value} is not a valid section"}
  validates :branch, presence: true, inclusion: {in: ["Main", "Second"], message: "%{value} is not a valid branch"}

  def self.current_year
    date = Date.today
    date.month > 4 ? date.year : date.year - 1
  end
end
