#!/usr/bin/env ruby

require 'slack-ruby-client'
require 'optparse'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail "Missing ENV['SLACK_API_TOKEN']!" unless config.token
end

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: slack-notifier.rb [options]"
  opts.on("-c","--channel CHANNEL","Channel Name") do |channel| 
    options[:channel] = channel
  end
  opts.on("-m","--message MESSAGE","Message") do |message|
    options[:message] = message
  end
  opts.on("-H", "--help", "Display this screen") do
    puts opts
    exit
  end
end
optparse.parse!

unless options[:channel] and options[:message]
  $stderr.puts "Error: Please specify channel name and message to be posted."
  exit
end

client = Slack::Web::Client.new

client.auth_test

client.chat_postMessage(channel: options[:channel], text: options[:message], as_user: true)
