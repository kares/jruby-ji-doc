
JRUBY_BASE_DIR = ENV['JRUBY_BASE_DIR'] || File.expand_path('..', File.dirname(__FILE__))

RB_DOC_FILES = File.join('core/src/main/ruby/jruby/java/**/*.rb')

require 'yard'

argv = [ '--no-private', '--hide-void-return' ]

argv.push '--readme', File.expand_path('README.md', File.dirname(__FILE__))

argv.push '--title', "JRuby's Java Integration"

argv.push '--no-cache'

argv.push '-o', File.expand_path(File.dirname(__FILE__)), RB_DOC_FILES

# require 'pp'

module YARD::RegisterDocstringHook
  def register(*objects, &block)
    obj = super(*objects, &block)
    if obj.docstring.nil? || obj.docstring.empty?
      if parent = statement.parent
        obj.docstring = parent.docstring
      end
    end
    obj
  end
end

class YARD::Handlers::Ruby::ModuleHandler
  include YARD::RegisterDocstringHook

  # process do
  #   modname = statement[0].source
  #   mod = register ModuleObject.new(namespace, modname)
  #
  #   #mod = ModuleObject.new(namespace, modname)
  #   # NOTE: register sets the docstring!
  #   #puts "bef0-process: modname = #{modname} - #{mod.inspect} docstring: #{mod.docstring.inspect}"
  #   #mod = register mod
  #
  #   begin
  #   if mod.docstring.nil? || mod.docstring.empty?
  #     if parent = statement.parent
  #       mod.docstring = parent.docstring
  #     end
  #     # while parent && parent.type != :comment
  #     #   parent = parent.parent
  #     # end
  #     #pp statement
  #   end
  #   rescue => e
  #     puts e.inspect
  #   end
  #   parse_block(statement[1], :namespace => mod)
  # end

end

class YARD::Handlers::Ruby::ClassHandler
  include YARD::RegisterDocstringHook
end

Dir.chdir JRUBY_BASE_DIR do
  YARD::CLI::CommandParser.run(*argv)
end

# yard -o ~/workspace/oss/jruby/._ji-doc/ ruby/jruby/java/**/*.rb

