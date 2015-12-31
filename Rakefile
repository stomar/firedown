# rakefile for the firedown script.
#
# Copyright (C) 2012-2015 Marcus Stollsteimer

require 'rake/testtask'

load 'firedown'

PROGNAME = Firedown::PROGNAME
HOMEPAGE = Firedown::HOMEPAGE
TAGLINE  = Firedown::TAGLINE

BINDIR = '/usr/local/sbin'
MANDIR = '/usr/local/man/man1'

HELP2MAN = 'help2man'
SED = 'sed'

BINARY = 'firedown'
MANPAGE = 'firedown.1'
H2MFILE = 'firedown.h2m'


#def gemspec_file
#  'firedown.gemspec'
#end


task :default => [:test]

Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
  t.libs   << '.'
  t.ruby_opts << '-rubygems'
  t.verbose = true
  t.warning = true
end


desc 'Install binary and man page'
task :install => [BINARY, MANPAGE] do
  mkdir_p BINDIR
  install(BINARY, "#{BINDIR}/#{BINARY}")
  mkdir_p MANDIR
  install(MANPAGE, MANDIR, :mode => 0644)
end


desc 'Uninstall binary and man page'
task :uninstall do
  rm "#{BINDIR}/#{BINARY}"
  manfile = File.basename(MANPAGE)
  rm "#{MANDIR}/#{manfile}"
end


desc 'Create man page'
task :man => [MANPAGE]

file MANPAGE => [BINARY, H2MFILE] do
  sh "#{HELP2MAN} --no-info --name='#{TAGLINE}' --include=#{H2MFILE} -o #{MANPAGE} ./#{BINARY}"
  sh "#{SED} -i 's/^License GPL/.br\\nLicense GPL/;s/There is NO WARRANTY/.br\\nThere is NO WARRANTY/' #{MANPAGE}"
  sh "#{SED} -i 's!%HOMEPAGE%!#{HOMEPAGE}!g' #{MANPAGE}"
  sh "#{SED} -i 's!%PROGNAME%!#{PROGNAME}!g' #{MANPAGE}"
end


#desc 'Build gem'
#task :build => [MANPAGE] do
#  sh "gem build #{gemspec_file}"
#end
