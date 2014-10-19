# test_logger.rb: Unit tests for the firedown script.
#
# Copyright (C) 2012-2014 Marcus Stollsteimer

require 'minitest/autorun'
load 'firedown'  unless defined?(Firedown)


describe Logger do

  before do
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.formatter = Firedown::Helper::log_formatter
  end

  it 'can add a log message in the correct format' do
    time = Time.utc(2012, 11, 10, 13, 14, 15, 123456)
    message = @logger.send(:format_message,
                           'INFO', time, 'ignored progname', 'Log message')
    message.must_equal "2012-11-10 13:14:15.123456  INFO: Log message\n"
  end

  it 'can return the logging level as string' do
    level = @logger.send(:format_severity, @logger.level)
    level.must_equal 'INFO'
  end
end
