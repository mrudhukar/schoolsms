module MessagesHelper
  def show_status(message)
    return "-" if message.blank?

    if message.status == Message::Status::SUCCESS
      "Successful"
    elsif message.status == Message::Status::FAILURE
      "Failure"
    elsif message.status == Message::Status::PENDING
      "Pending Delivery"
    end
  end

  def show_message(message)
    return "No SMS sent yet" if message.blank?

    if message.status == Message::Status::SUCCESS
      "Successful"
    elsif message.status == Message::Status::FAILURE
      "Failure"
    elsif message.status == Message::Status::PENDING
      "Pending Delivery"
    end
  end

  def recepient_collection
    [
      ["Only Mothers", Parent::RelationShip::MOTHER],
      ["Only Fathers", Parent::RelationShip::FATHER]
    ]
  end
end
