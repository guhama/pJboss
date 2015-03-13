target_env = ENV['TARGET_ENV']

if target_env == 'local'
  require 'support/ci_helper'
elsif target_env == 'vagrant'
  require 'support/vagrant_helper'
else
  raise "Unkown 'target_env'=#{target_env}"
end
