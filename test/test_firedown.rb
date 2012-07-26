#!/usr/bin/ruby -w

require 'minitest/spec'
require 'minitest/autorun'
load 'firedown'


describe Firedown::Optionparser do

  it 'should return the correct default values' do
    options = Firedown::Optionparser.parse!(['/home/sample_dir'])
    expected = {
      :daemon_mode => false,
      :directories => ['/home/sample_dir'],
      :log         => false,
      :log_file    => '/var/log/firedown.log',
      :log_level   => :info,
      :simulate    => false
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


# monkey patch for Minitest:
# use regexp instead of string for assert_output / must_output
module MiniTest
  module Assertions
    def assert_output stdout = nil, stderr = nil
      out, err = capture_io do
        yield
      end

      stdout = /\A#{stdout}\Z/  if stdout.class == String
      stderr = /\A#{stdout}\Z/  if stderr.class == String

      y = assert_match stderr, err, "In stderr" if stderr
      x = assert_match stdout, out, "In stdout" if stdout

      (!stdout || x) && (!stderr || y)
    end
  end
end

describe Firedown::Logger do

  before do
    @logger = Firedown::Logger.new('STDERR')
  end

  it 'should return the time in the correct format' do
    time = Time.utc(2012, 6, 26, 20, 0, 0)
    time_string = Firedown::Logger::time_to_string(time)
    time_string.must_equal '2012-06-26 20:00:00 UTC'
  end

  it 'should have a default level' do
    @logger.level.must_equal :info
  end

  it 'can add a log message in the correct format' do
    lambda { @logger.add 'Log message' }.must_output '', /[\d-]+ [\d:]+ \w+: Log message/  # patched
  end

  it 'does not log debug messages' do
    lambda { @logger.warn  'Warn message'  }.must_output '', /Warn message/  # patched
    lambda { @logger.info  'Info message'  }.must_output '', /Info message/  # patched
    lambda { @logger.debug 'Debug message' }.must_be_silent
  end

  it 'logs all messages in :debug mode' do
    @logger.level = :debug
    lambda { @logger.warn  'Warn message'  }.must_output '', /Warn message/   # patched
    lambda { @logger.info  'Info message'  }.must_output '', /Info message/   # patched
    lambda { @logger.debug 'Debug message' }.must_output '', /Debug message/  # patched
  end

  it 'logs only warn messages in :warn mode' do
    @logger.level = :warn
    lambda { @logger.warn  'Warn message'  }.must_output '', /Warn message/   # patched
    lambda { @logger.info  'Info message'  }.must_be_silent
    lambda { @logger.debug 'Debug message' }.must_be_silent
  end

end
