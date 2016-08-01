class CreateStudentYears < ActiveRecord::Migration[5.0]
  def change
    create_table :student_years do |t|
      t.belongs_to :student

      t.integer :academic_year, null: false
      t.string :classroom, null: false
      t.string :section
      t.string :branch, null: false, default: "Main"

      t.timestamps
    end
  end
end
