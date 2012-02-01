Gem::Specification.new do |s|
	s.name = 'w32evol_ruby'
	s.version = '0.0.2'
	s.date = '2012-01-31'
	s.summary = 'A Ruby wrapper for the w32evol obfuscation engine'
	s.description = 'Provides a Ruby wrapper for the w32evol obfuscation engine'
	s.authors = ['Martin Velez']
	s.email = 'mvelez999@gmail.com'
	s.files = Dir["lib/**/*","ext/**/*","examples/**/*","test/**/*","README.rdoc"]
	s.homepage = 'http://bitbucket.org/martinvelez/w32evol'
	s.require_paths = ["lib"]
end
