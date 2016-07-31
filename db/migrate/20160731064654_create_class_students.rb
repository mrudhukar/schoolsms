class CreateClassStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :class_students do |t|
      t.belongs_to :student

      t.integer :year, null: false
      t.string :class, null: false
      t.string :section
      t.string :branch, null: false, default: "Main"

      t.timestamps
    end
  end
end
