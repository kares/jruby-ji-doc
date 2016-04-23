
JRUBY_BASE_DIR = ENV['JRUBY_BASE_DIR'] || File.expand_path('..', File.dirname(__FILE__))

RB_DOC_FILES = File.join('core/src/main/ruby/jruby/java/**/*.rb')

require 'yard'

argv = [ '--no-private', '--hide-void-return' ]

argv.push '--readme', File.expand_path('README.md', File.dirname(__FILE__))

argv.push '--title', "JRuby's Java Integration"

argv.push '--no-cache'

argv.push '-o', File.expand_path(File.dirname(__FILE__)), RB_DOC_FILES

=begin
class YARD::Handlers::Ruby::CommentHandler
  #handles :comment, :void_stmt
  #namespace_only

  process do
    # puts "registed_docstring nil: #{statement.inspect}"
    # puts "registed_docstring nil: #{statement.docstring.inspect}"
    # if statement.type == :comment && statement.docstring
    #   register_docstring(statement.docstring)
    # else
    #   register_docstring(nil)
    # end
    register_docstring(nil)
  end
end
=end

# require 'pp'

class YARD::Handlers::Ruby::ModuleHandler
  # handles :module
  # namespace_only

  process do
    modname = statement[0].source
    mod = register ModuleObject.new(namespace, modname)

    #mod = ModuleObject.new(namespace, modname)
    # NOTE: register sets the docstring!
    #puts "bef0-process: modname = #{modname} - #{mod.inspect} docstring: #{mod.docstring.inspect}"
    #mod = register mod

    begin
    if mod.docstring.nil? || mod.docstring.empty?
      if parent = statement.parent
        mod.docstring = parent.docstring
      end
      # while parent && parent.type != :comment
      #   parent = parent.parent
      # end
      #pp statement
    end
    rescue => e
      puts e.inspect
    end

    #puts "bef-process: modname = #{modname} - #{mod.inspect} docstring: #{mod.docstring.inspect}"

    #ast = parse_block(statement[1], :namespace => mod)
    #puts "process: modname = #{modname} - #{mod.inspect}\n #{mod.docstring}\n statement = #{statement[1]} ast.doc = #{ast.docstring}"
    #puts "aft-process: modname = #{modname} - #{mod.inspect} docstring: #{mod.docstring.inspect}"

    # mod ... (YARD::CodeObjects::ModuleObject
    # begin
    #   if modname == 'Java::java::util::Iterator'
    #
    #     # puts "YARD::Registry.all.size = #{YARD::Registry.all.size}"
    #     # YARD::Registry.all.each do |obj|
    #     #   puts ' - ' + obj.inspect
    #     # end
    #
    #     #puts "XXXXXXXXXXXXXXXXXX #{modname} statement: "; pp statement
    #     #puts "YYYYYYYYYYYYYYYYYY #{modname} statement.parent: "; pp statement.parent
    #
    #     puts "ZZZZZZZZZZZ #{modname} statement.parent.docstring: #{statement.parent.docstring.inspect}"
    #     # ast.traverse { |child| puts " child = #{child} #{child.docstring}" }
    #   end
    # rescue => e
    #   puts e.inspect
    #   e.backtrace.each { |b| puts "  #{b}" }
    # end

    #ast # parse_block(statement[1], :namespace => mod)
    parse_block(statement[1], :namespace => mod)
  end

  # def register_docstring(object, docstring = statement.comments, stmt = statement)
  #   docstring = docstring.join("\n") if Array === docstring
  #   parser = YARD::Docstring.parser
  #   parser.parse(docstring || "", object, self)
  #
  #   puts "reg_doc #{object} #{statement.class} stmt.parent = #{statement.parent.inspect} stmt.comments = #{statement.comments.inspect}"
  #   # statement ... YARD::Parser::Ruby::ModuleNode -> YARD::Parser::Ruby::AstNode
  #
  #   # comments = find_comments(statement.parent)
  #   # puts " comment parents: #{comments.size} - #{comments.inspect}"
  #
  #   if object && docstring
  #     object.docstring = parser.to_docstring
  #
  #     # Add hash_flag/line_range
  #     if stmt
  #       object.docstring.hash_flag = stmt.comments_hash_flag
  #       object.docstring.line_range = stmt.comments_range
  #     end
  #   end
  #
  #   register_transitive_tags(object)
  # end
  #
  # def find_comments(ast)
  #   comments = []
  #   ast.each do |ast|
  #     if ast.type == :comment
  #       comments << ast
  #     else
  #       comments += find_comments(ast) unless ast.size == 0
  #     end
  #   end
  #   comments
  # end

end

Dir.chdir JRUBY_BASE_DIR do
  YARD::CLI::CommandParser.run(*argv)
end

# yard -o ~/workspace/oss/jruby/._ji-doc/ ruby/jruby/java/**/*.rb

