# test_firedown.rb: Unit tests for the firedown script.
#
# Copyright (C) 2012 Marcus Stollsteimer

require 'minitest/spec'
require 'minitest/autorun'
load 'firedown'  unless defined?(Firedown)


describe Firedown::Optionparser do

  it 'should return the correct default values' do
    options = Firedown::Optionparser.parse!(['/home/sample_dir'])
    expected = {
      :daemon_mode => false,
      :directories => ['/home/sample_dir'],
      :log         => false,
      :log_file    => '/var/log/firedown.log',
      :log_level   => :info,
      :simulate    => false,
      :sleep_time  => 15
    }
    options.must_equal expected
  end

  it "should strip last '/' from directories" do
    options = Firedown::Optionparser.parse!(['/sample_dir1/'])
    options[:directories].must_equal ['/sample_dir1']
  end

  it "should accept more than one directory" do
    options = Firedown::Optionparser.parse!(['/sample_dir1', '/sample_dir2'])
    options[:directories].must_equal ['/sample_dir1', '/sample_dir2']
  end

  it 'should recognize the -d option' do
    options = Firedown::Optionparser.parse!(['sample_dir', '-d'])
    options[:daemon_mode].must_equal true
    options[:log].must_equal true
  end

  it 'must override the --no-log option in daemon mode' do
    options = Firedown::Optionparser.parse!(['sample_dir', '--no-log'])
    options[:log].must_equal false
    options = Firedown::Optionparser.parse!(['sample_dir', '-d', '--no-log'])
    options[:log].must_equal true
  end

  it 'should recognize the --logging-level option' do
    options = Firedown::Optionparser.parse!(['sample_dir', '--logging-level', 'debug'])
    options[:log_level].must_equal :debug
  end

  it 'should recognize the -n option' do
    options = Firedown::Optionparser.parse!(['sample_dir', '-n'])
    options[:simulate].must_equal true
  end

  it 'should not accept wrong number of arguments' do
    lambda { Firedown::Optionparser.parse!(['']) }.must_raise ArgumentError
    lambda { Firedown::Optionparser.parse!([]) }.must_raise ArgumentError
  end

  it 'should not accept invalid options' do
    lambda { Firedown::Optionparser.parse!(['-x']) }.must_raise OptionParser::InvalidOption
  end
end


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
