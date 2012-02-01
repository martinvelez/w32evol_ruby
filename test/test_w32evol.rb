require 'minitest/autorun'
require 'w32evol'

class TestW32Evol < MiniTest::Unit::TestCase
	
	def setup
		@engine = W32Evol.new
		@input = "\x83\xC0\x0A" 
	end

	def test_obfuscate
		output, errors, status = @engine.obfuscate(@input)
		assert_equal "\x81\xC0\x0A\x00\x00\x00", output
		assert_equal "", errors
		assert_equal 0, status
	end
end

