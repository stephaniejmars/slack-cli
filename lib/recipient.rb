require 'HTTParty'
require 'dotenv'
require_relative 'workspace'
require_relative 'channel'
require_relative 'user'
require_relative 'slack'

# Dotenv.load # not needed bc its in slack and test helper 

class SlackAPIError < Exception
end

class Recipient

  attr_reader :slack_id, :name 

  def initialize(name, slack_id)
    @name = name 
    @slack_id = slack_id
  end 

  def self.get(url)
    data = HTTParty.get(url, query: {token: ENV["SLACK_API_TOKEN"]})
    if data.code != 200 || data["ok"] == false 
      raise SlackAPIError, "We encountered a problem: #{data["error"]}"
    end 
    return data 
  end


  def send_message(message)
    response = HTTParty.post("https://slack.com/api/chat.postMessage", query: {token: ENV["BOT_API_TOKEN"], channel: self.slack_id, text: message})
    if response.code != 200 || response["ok"] == false 
      raise SlackAPIError, "We encountered a problem: #{response["error"]}"
    else
      puts "Message sent"
    end
  end

  def details 
    raise NotImplimentedError, "Define this method in a child class"
  end 

  def self.list_all
    raise NotImplimentedError, "Define this method in a child class"
  end

end
