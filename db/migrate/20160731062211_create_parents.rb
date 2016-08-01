class CreateParents < ActiveRecord::Migration[5.0]
  def change
    create_table :parents do |t|
      t.belongs_to :student
      t.string :phone
      t.string :name
      t.string :email
      t.string :relation
      t.string :occupation


      t.timestamps
    end
  end
end
