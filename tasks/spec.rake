require 'rspec/core/rake_task'

namespace :spec do
  desc 'prepares fixtures for spec examples'
  task :fixtures do
    verbose(false) do
      sh 'bundle exec rspec-puppet-init'
      FileUtils.rm_rf([
        'spec/classes',
        'spec/defines',
        'spec/functions',
        'spec/hosts'
      ])
      sh 'bundle exec librarian-puppet install --path=spec/fixtures/modules'
    end
  end

  namespace :local do
    desc 'run unit tests'
    RSpec::Core::RakeTask.new(:unit => :fixtures) do |t|
      t.pattern = 'spec/unit/*/*_spec.rb'
    end

    desc 'run integration tests against a vagrant machine'
    RSpec::Core::RakeTask.new(:integration => :fixtures) do |t|
      ENV['TARGET_ENV'] = 'vagrant'
      t.pattern = 'spec/integration/*_spec.rb'
    end
  end

  namespace :ci do
    desc 'run unit tests'
    RSpec::Core::RakeTask.new(:unit => :fixtures) do |t|
      t.pattern = 'spec/unit/*/*_spec.rb'
      t.rspec_opts = '--format html --out reports/unit_results.html'
    end

    desc 'run rspec with an HTML formatter'
    RSpec::Core::RakeTask.new(:integration => :fixtures) do |t|
      ENV['TARGET_ENV'] = 'local'
      t.pattern = 'spec/integration/*_spec.rb'
      t.rspec_opts = '--format html --out reports/integration_results.html'
    end
  end
end
