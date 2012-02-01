require 'rake/testtask'
require 'rake/clean'

CLEAN.include("*.gem")

Rake::TestTask.new do |t|
	t.libs << 'test'
	t.test_files = FileList["test/test_*.rb"]
	t.verbose = true
end

desc "Run tests"
task :default => :test

task :build do 
	system "gem build w32evol_ruby.gemspec"
end
