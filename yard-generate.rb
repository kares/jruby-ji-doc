
JRUBY_BASE_DIR = ENV['JRUBY_BASE_DIR'] || File.expand_path('..', File.dirname(__FILE__))

RB_DOC_FILES = File.join('core/src/main/ruby/jruby/java/**/*.rb')

require 'yard'

argv = [ '--no-private', '--hide-void-return' ]

argv.push '--readme', File.expand_path('README.md', File.dirname(__FILE__))

argv.push '--title', "JRuby's Java Integration"

argv.push '--no-cache'

argv.push '--template-path', File.expand_path('yard', File.dirname(__FILE__)) 

argv.push '-o', File.expand_path(File.dirname(__FILE__)), RB_DOC_FILES

module YARD::RegisterDocstringHook
  def register_docstring(object, *args)
    if object.docstring.nil? || object.docstring.empty?
      if parent = statement.parent
        object.docstring = parent.docstring
      end
    end
    super(object, *args)
  end
end

class YARD::Handlers::Ruby::ModuleHandler
  include YARD::RegisterDocstringHook
end

class YARD::Handlers::Ruby::ClassHandler
  include YARD::RegisterDocstringHook
end

Dir.chdir JRUBY_BASE_DIR do
  YARD::CLI::CommandParser.run(*argv)
end

# yard -o ~/workspace/oss/jruby/._ji-doc/ ruby/jruby/java/**/*.rb
