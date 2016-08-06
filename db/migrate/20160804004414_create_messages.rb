class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.text :criteria
      t.text :response
      t.integer :send_to
      t.integer :status, default: Message::Status::PENDING

      t.timestamps
    end
  end
end
