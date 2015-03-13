require 'spec_helper'

describe 'jboss::datasource_driver', :type => :define do
  artifact_url = 'http://nexus.repo.com/ojdbc-11.5.jar'
  deploy_dir = '/deployments_dir'
  datasource_driver_title = 'ojdbc.jar'
  driver_name = 'myojdbc.jar'
  user = 'custom_user'

  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  let('title') { datasource_driver_title }
  context 'when :url => undef' do
    it {
      expect {
        should have_resource_count(0)
      }.to raise_error(Puppet::Error, /:url parameter must be provided/)
    }
  end

  context "when :deploy_dir => undef" do
    let(:params) {{
      :url => artifact_url,
    }}

    it {
      expect {
        should have_resource_count(0)
      }.to raise_error(Puppet::Error, /:deploy_dir parameter must be provided/)
    }
  end

  context "when :name => '#{driver_name}'" do
    let(:params) {{
      :url        => artifact_url,
      :name       => driver_name,
      :deploy_dir => deploy_dir,
    }}

    it {
      should contain_wget__fetch("#{artifact_url}")
      .with_destination("#{deploy_dir}/#{driver_name}")
      .with_timeout(0)
      .with_verbose(false)
      .with_execuser('root')
    }
  end

  context "when :name is not provided, then it resolves to the datasource_driver's title" do
    let(:params) {{
      :url        => artifact_url,
      :deploy_dir => deploy_dir,
    }}

    it {
      should contain_wget__fetch("#{artifact_url}")
      .with_destination("#{deploy_dir}/#{datasource_driver_title}")
      .with_timeout(0)
      .with_verbose(false)
      .with_execuser('root')
    }
  end

  context "when :user => #{user}" do
    let(:params) {{
      :url        => artifact_url,
      :deploy_dir => deploy_dir,
      :user       => user,
    }}

    it {
      should contain_wget__fetch("#{artifact_url}")
      .with_destination("#{deploy_dir}/#{datasource_driver_title}")
      .with_timeout(0)
      .with_verbose(false)
      .with_execuser(user)
    }
  end
end
