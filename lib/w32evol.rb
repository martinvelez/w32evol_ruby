require 'tempfile'

# This class wraps the w32evol obfuscation engine.
# {w32evol}[https://bitbucket.org/martinvelez/w32evol]
class W32Evol

	# By default the engine is distributed in the ext folder of this gem.
	# This constant allows us to find the path to the engine executable. 
	ENGINE_ROOT 	= File.expand_path(File.join(File.dirname(__FILE__), '..'))
	BINARY 				= true # input is in binary format
	NOSTDIN 			= true # does not accept standard input
	PLATFORM			= "windows" # windows program (requires wine in Linux) 
	
	attr_reader :options

	# The user can instantiate this class by passing in a Hash of options
	# 
	# Default options:
	#
	# By default the engine is distributed with this gem in the "ext" folder
	#  :command => File.join(ENGINE_ROOT,"ext","bin","w32evol.exe")
	#	
	def initialize(options = {})
		@name = self.class.to_s.downcase
		@options = default_options.merge(options)
		@command = generate_command
		@command_options = generate_command_options
	end
	
	# this method obfuscates code and provides the obfuscated code, errors 
	# produced by the engine, and the engine's exit status
	#  Binary String or filename: input
	#  Binary String: output
	#	 String: errors
	#  Integer: exitstatus
	#  obfuscate(input) => output, errors, exitstatus
	def obfuscate(input)
		output, errors, exitstatus = "", "", 0
	
		# if input string contains the \xnn escape sequence, 
		# then we can assume that it is code
		# For example, let input = "\x83\xC0\x0A"
		# Then input.inspect => "\"\\x83\"".
		# Thus, input.inspect =~ /\\x../ => 1
		if (input.inspect =~ /\\x.*/) >= 0
			infile = Tempfile.open(["#{@name}_in",'.bin']) do |f| 
				f.binmode
				f.syswrite input
				f.path
			end 
		else
			raise("#{input}: File does not exists or is not readable") \
				unless File.exist?(input) and File.readable?(input)
		end
	
		outfile = Tempfile.open(["#{@name}_out",'.bin']) {|f| f.path }	
		return obfuscate_inner(infile, outfile)		
	end

	private
		# This method defines the default options in a Hash
		# 
		# By default, the engine is expected to be in the "ext" folder.
		# 
		def default_options
			{
				# By default the engine is in the ext folder of this gem
				# This assumes that the wine command in in your PATH
				:command => File.join(ENGINE_ROOT,"ext","#{@name}.exe")
			}
		end

		# This method converts the options Hash into a string of flags for the 
		# command line call.
		#
		# Example output:
		#  "--x cpp --x iso --x motif --x posix2 --x stl --x unix95 --x xpg4" 
		def generate_command_options
			command_options = ""
			@options.each do |key, value|
				if key.to_s != "command"
					if value.kind_of?(Array)
						value.each{|val| command_options += "#{key} #{val} "}
					elsif
						command_options += "#{key} #{value} "
					end		
				end
			end
			command_options.rstrip
		end

		# This method obfuscate the code in infile and stores in outfile
		#
		# It is used for engines with a command line interface which requires an input 
		# file name, and an output file name.
		def obfuscate_inner(infile, outfile)
			# This engine does not output to stderr, it only returns an exit code if it
			# fails.	
			output, errors, exitstatus = "", "", 0
			system("#{@command} #{infile} #{outfile}")
			exitstatus = $?.exitstatus		
			if exitstatus == 0 # if engine success
				f = File.new(outfile)
				output = f.sysread(f.size)
				f.close
			end	
			return output, errors, exitstatus	
		end

		def generate_command
			if PLATFORM == 'windows'
				return "wine #{@options[:engine]}" if RUBY_PLATFORM =~ /linux/
			elsif PLATFORM == 'java'
				return "java -jar #{@options[:engine]}"
			end
			return @options[:engine]
		end

end

