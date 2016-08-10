require "rubygems"
require "net/https"
require "uri"
require "json"

class Message < ApplicationRecord
  module Status
    PENDING = 0
    SUCCESS = 1
    FAILURE = 2

    ALL = [PENDING, SUCCESS, FAILURE]
  end

  validates :content, presence: true, length: {maximum: 160}
  validates :status, presence: true, inclusion: {in: Status::ALL, message: "%{value} is not a valid class"}
  validates :criteria, presence: true

  attr_accessor :error_message

  
  def self.get_current_balance
    requested_url = 'http://api.textlocal.in/balance?'
           
    uri = URI.parse(requested_url)
    res = Net::HTTP.post_form(uri, 'apiKey': ENV['SMS_API_KEY'])
    response = JSON.parse(res.body)
    
    if response["status"] == "success"
      response["balance"]["sms"]
    else
      "Error"
    end

    rescue SocketError
      "Error"
  end

  def send_sms(numbers)
    requested_url = 'http://api.textlocal.in/send/?'

    uri = URI.parse(requested_url)
    params = {'apiKey': ENV['SMS_API_KEY'], 'message': self.content, 'numbers': numbers.join(","), 'custom': self.id}
    params['sender'] = ENV['SMS_SENDER'] if ENV['SMS_SENDER'].present?
    res = Net::HTTP.post_form(uri, params)
    response = JSON.parse(res.body)

    case response["status"]
    when "success"
      self.status = Status::SUCCESS
    when "failure"
      self.status = Status::FAILURE
    else
      self.status = Status::FAILURE
      invalid = true
    end

    self.response = Base64.encode64(Marshal.dump(response))
    self.save!

    if invalid
      raise "Invalid message response status #{response['status']}" 
    else
      self.error_message = response["errors"].collect{|er| er["message"]}.join(", ") if self.status == Status::FAILURE
      return self.status == Status::SUCCESS
    end
  end

  def criteria_hash
    self.criteria ? Marshal.load(Base64.decode64(self.criteria)) : {}
  end

  def response_hash
    self.response ? Marshal.load(Base64.decode64(self.response)) : {}
  end

end


#TODO
# Setup recepient infrastructure
# Close on the sender (transactional messages)
# SMS Alert to admins on low sms balance
