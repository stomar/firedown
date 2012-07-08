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


describe Firedown::Helpers do

  it 'should return the time in the correct format' do
    time = Time.utc(2012, 6, 26, 20, 0, 0)
    time_string = Firedown::Helpers::time_to_string(time)
    time_string.must_equal '2012-06-26 20:00:00 UTC'
  end

end
