class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.belongs_to :student_year
      t.date :absent_on, null: false
      t.integer :absent_type, null: false, default: Attendance::AbsentType::FULLDAY

      t.text :reason

      t.timestamps
    end
  end
end
