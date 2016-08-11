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

  def show_status_label(message)
    if message.status == Message::Status::SUCCESS
      content_tag(:span, "Successful", class: "label label-primary")
    elsif message.status == Message::Status::FAILURE
      content_tag(:span, "Failure", class: "label label-danger")
    elsif message.status == Message::Status::PENDING
      content_tag(:span, "Pending Delivery", class: "label label-warning")
    end
  end

  def show_message_criteria(message)
    message.criteria_hash.
    reject{|k,v| ["with_number","with_academic_year"].include?(k) }.
    collect{|k,v| "#{cleanup_keys(k)}: #{v}" }.
    join(", ")
  end

  def show_message_response(message)
    return "-" if message.status == Message::Status::PENDING

    message.response_hash.collect{|k,v| "#{k}: #{v}"}.join(", ")
  end

  def recepient_collection
    [
      ["Only Mothers", Parent::RelationShip::MOTHER],
      ["Only Fathers", Parent::RelationShip::FATHER]
    ]
  end

  private

  def cleanup_keys(string)
    string.gsub('with_','').gsub('klass','class').capitalize
  end

end
