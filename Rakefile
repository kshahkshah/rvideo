require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'fileutils'
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts 'To use rspec for testing you must install rspec gem:'
  puts '$ sudo gem install rspec'
  exit
end

include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'rvideo', 'version')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "rvideo-whistlerbrk"
    gemspec.summary     = "rvideo 0.9.4"
    gemspec.description = "rvideo 0.9.4 doesn't appear to have been published as a gem, I'm publishing it"
    gemspec.email       = "kunal@dropio.com"
    gemspec.homepage    = "http://github.com/whistlerbrk/rvideo"
    gemspec.authors     = ['Jonathan Dahl (Slantwise Design)', 'Kunal Shah (drop.io)']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

#require 'spec/rake/spectask'
require File.dirname(__FILE__) + '/lib/rvideo'

namespace :spec do
  desc "Run Unit Specs"
  Spec::Rake::SpecTask.new("units") do |t| 
    t.spec_files = FileList['spec/units/**/*.rb']
  end

  desc "Run Integration Specs"
  Spec::Rake::SpecTask.new("integrations") do |t| 
    t.spec_files = FileList['spec/integrations/**/*.rb']
  end
end

desc "Process a file"
task(:transcode) do
  RVideo::Transcoder.logger = Logger.new(STDOUT)
  transcode_single_job(ENV['RECIPE'], ENV['FILE'])
end

desc "Batch transcode files"
task(:batch_transcode) do
  RVideo::Transcoder.logger = Logger.new(File.dirname(__FILE__) + '/test/output.log')
  f = YAML::load(File.open(File.dirname(__FILE__) + '/test/batch_transcode.yml'))
  recipes = f['recipes']
  files = f['files']
  files.each do |f|
    file = "#{File.dirname(__FILE__)}/test/files/#{f}"
    recipes.each do |recipe|
      transcode_single_job(recipe, file)
    end
  end
end

def transcode_single_job(recipe, input_file)
  puts "Transcoding #{File.basename(input_file)} to #{recipe}"
  r = YAML::load(File.open(File.dirname(__FILE__) + '/test/recipes.yml'))[recipe]
  transcoder = RVideo::Transcoder.new(input_file)
  output_file = "#{TEMP_PATH}/#{File.basename(input_file, ".*")}-#{recipe}.#{r['extension']}"
  FileUtils.mkdir_p(File.dirname(output_file))
  begin
    transcoder.execute(r['command'], {:output_file => output_file}.merge(r))
    puts "Finished #{File.basename(output_file)} in #{transcoder.total_time}"
  rescue StandardError => e
    puts "Error transcoding #{File.basename(output_file)} - #{e.class} (#{e.message}\n#{e.backtrace})"
  end
end
