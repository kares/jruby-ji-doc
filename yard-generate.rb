
JRUBY_BASE_DIR = ENV['JRUBY_BASE_DIR'] || File.expand_path('..', File.dirname(__FILE__))

RB_DOC_FILES = File.join('core/src/main/ruby/jruby/java/**/*.rb')

require 'yard'

argv = [ '--no-private', '--hide-void-return' ]

argv.push '--readme', File.expand_path('README.md', File.dirname(__FILE__))

argv.push '-o', File.expand_path(File.dirname(__FILE__)), RB_DOC_FILES

Dir.chdir JRUBY_BASE_DIR do
  YARD::CLI::CommandParser.run(*argv)
end

# yard -o ~/workspace/oss/jruby/._ji-doc/ ruby/jruby/java/**/*.rb

