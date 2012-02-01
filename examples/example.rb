#!/usr/bin/env ruby

#require 'w32evol_ruby'
require '../lib/w32evol.rb'

ARGF.binmode
input = ARGF.read
# Assuming engine is installed in this gem's "ext" folder.
# Otherwise, you must pass the engine's executable path to the class's 
# constructor.
# For example:
# engine = W32Evol.new({:command => "/path/to/engine"})
engine = W32Evol.new

output, errors, status = engine.obfuscate(input)

puts "INPUT:", input.inspect
puts "STATUS:", status
puts "ERRORS: ", errors
puts "OUTPUT:", output.inspect
