require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the pg_gnostic plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the pg_gnostic plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'kung_figure'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


PKG_FILES = FileList[ '[a-zA-Z]*', 'generators/**/*', 'lib/**/*', 'rails/**/*', 'tasks/**/*', 'test/**/*' ]

spec = Gem::Specification.new do |s|
  s.name = "kung_figure"
  s.version = "0.0.3"
  s.author = "niquola"
  s.email = "niquola@gmail.com"
  s.homepage = "http://github.com/niquola/kung_figure"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby configuration DSL base"
  s.files = PKG_FILES.to_a 
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.rdoc"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
