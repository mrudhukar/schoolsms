class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name

      t.integer :phone
      t.string :email
      
      t.date :date_of_birth
      t.date :joined_on
      t.date :left_on

      t.string :gender
      t.string :caste

      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
