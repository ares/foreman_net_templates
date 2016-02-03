# Tasks
namespace :foreman_net_templates do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanNetTemplates'
  Rake::TestTask.new(:foreman_net_templates) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
  end
end

namespace :foreman_net_templates do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_net_templates) do |task|
        task.patterns = ["#{ForemanNetTemplates::Engine.root}/app/**/*.rb",
                         "#{ForemanNetTemplates::Engine.root}/lib/**/*.rb",
                         "#{ForemanNetTemplates::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_net_templates'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_net_templates'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:foreman_net_templates'].invoke
    Rake::Task['foreman_net_templates:rubocop'].invoke
  end
end
