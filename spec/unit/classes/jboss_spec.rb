require 'spec_helper'

describe 'jboss', :type => :class do
  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  context "when 'source_path' parameter is undef" do
    it {
      expect {
        should_not include_class('jboss::dependencies')
        should_not include_class('jboss::install')
        should_not include_class('jboss::service')
      }.to raise_error(Puppet::Error, /"source_path" parameter must be provided/)
    }
  end

  context "when 'source_file' parameter is undef" do
    let(:params) {{
      :source_path => 'puppet:///mount_point/jboss',
    }}

    it {
      expect {
        should_not include_class('jboss::dependencies')
        should_not include_class('jboss::install')
        should_not include_class('jboss::service')
      }.to raise_error(Puppet::Error, /"source_file" parameter must be provided/)
    }
  end

  context "when 'install_dir' parameter is undef" do
    let(:params) {{
      :source_path => 'puppet:///mount_point/jboss',
      :source_file => 'jboss.zip',
    }}

    it {
      expect {
        should_not include_class('jboss::dependencies')
        should_not include_class('jboss::install')
        should_not include_class('jboss::service')
      }.to raise_error(Puppet::Error, /"install_dir" parameter must be provided/)
    }
  end

  context "when provided all required parameters" do
    let(:params) {{
      :source_path => 'puppet:///mount_point/jboss',
      :source_file => 'jboss.zip',
      :install_dir => 'jboss-as',
    }}

    it { should include_class('jboss::dependencies') }
    it { should include_class('jboss::install') }
    it { should include_class('jboss::service') }
  end
end
