require 'spec_helper'

describe 'jboss::dependencies', :type => :class do


  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  it {
    should contain_package('unzip')
    .with_ensure('installed')
  }
end
