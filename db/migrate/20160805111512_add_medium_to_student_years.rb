class AddMediumToStudentYears < ActiveRecord::Migration[5.0]
  def change
    add_column :student_years, :medium, :string, default: StudentYear::Medium::ENGLISH
  end
end
