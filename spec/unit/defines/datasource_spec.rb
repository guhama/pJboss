require 'spec_helper'

describe 'jboss::datasource', :type => :define do
  context "with :url => undef" do
    let(:title) { 'datasource' }
    let(:params) {{
      :username      => 'le_username',
      :password      => 'le_password',
      :jndi_name     => 'le_jndi_name',
      :deploy_folder => '/opt/deployments',
    }}

    let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
    it {
      expect {
        should_not contain_file('/opt/deployments/datasource-ds.xml')
      }.to raise_error(Puppet::Error, /:url parameter must be provided/)
    }
  end

  context "with :username => undef" do
    let(:title) { 'datasource' }
    let(:params) {{
      :url           => 'le_url',
      :password      => 'le_password',
      :jndi_name     => 'le_jndi_name',
      :deploy_folder => '/opt/deployments',
    }}

    it {
      expect {
        should_not contain_file('/opt/deployments/datasource-ds.xml')
      }.to raise_error(Puppet::Error, /:username parameter must be provided/)
    }
  end

  context "with :password => undef" do
    let(:title) { 'datasource' }
    let(:params) {{
      :url           => 'le_url',
      :username      => 'le_username',
      :jndi_name     => 'le_jndi_name',
      :deploy_folder => '/opt/deployments',
    }}

    it {
      expect {
        should_not contain_file('/opt/deployments/datasource-ds.xml')
      }.to raise_error(Puppet::Error, /:password parameter must be provided/)
    }
  end

  context "with :jndi_name => undef" do
    let(:title) { 'datasource' }
    let(:params) {{
      :url           => 'le_url',
      :username      => 'le_username',
      :password      => 'le_password',
      :deploy_folder => '/opt/deployments',
    }}

    it {
      expect {
        should_not contain_file('/opt/deployments/datasource-ds.xml')
      }.to raise_error(Puppet::Error, /:jndi_name parameter must be provided/)
    }
  end

  context "with :deploy_folder => undef" do
    let(:title) { 'datasource' }
    let(:params) {{
      :url       => 'le_url',
      :username  => 'le_username',
      :password  => 'le_password',
      :jndi_name => 'le_jndi_name',
    }}

    it {
      expect {
        should_not contain_file('/opt/deployments/datasource-ds.xml')
      }.to raise_error(Puppet::Error, /:deploy_folder parameter must be provided/)
    }
  end

  context 'with default parameters' do
    let(:title) { 'app' }
    let(:params) {{
      :url           => 'jdbc:fake:url',
      :username      => 'le_username',
      :password      => 'le_password',
      :jndi_name     => 'le_jndi_name',
      :deploy_folder => '/opt/deployments',
    }}

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_ensure('present')
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<datasource.+jta="false".*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<datasource.+jndi-name="le_jndi_name".*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<datasource.+pool-name="default-db-pool".*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<driver-class>oracle\.jdbc\.OracleDriver<\/driver-class>.*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<driver>ojdbc6g-11\.2\.0\.2\.0\.jar<\/driver>.*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<new-connection-sql>select 1 from dual<\/new-connection-sql>.*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<connection-url>jdbc:fake:url<\/connection-url>.*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<user-name>le_username<\/user-name>.*/)
    }

    it {
      should contain_file('/opt/deployments/app-ds.xml')
      .with_content(/.*<password>le_password<\/password>.*/)
    }
  end

  context 'with custom parameters' do
    let(:title) { 'another-app' }
    let(:params) {{
      :url                => 'jdbc:another_fake:url',
      :username           => 'username',
      :password           => 'password',
      :jndi_name          => 'jndi_name',
      :deploy_folder      => '/opt/deployments',
      :jta                => true,
      :pool_name          => 'le-pool-name',
      :driver_class       => 'le_driver_class',
      :driver             => 'le_driver',
      :new_connection_sql => 'select 5 from table',
    }}

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_ensure('present')
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<datasource.+jta="true".*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<datasource.+jndi-name="jndi_name".*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<datasource.+pool-name="le-pool-name".*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<driver-class>le_driver_class<\/driver-class>.*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<driver>le_driver<\/driver>.*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<new-connection-sql>select 5 from table<\/new-connection-sql>.*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<connection-url>jdbc:another_fake:url<\/connection-url>.*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<user-name>username<\/user-name>.*/)
    }

    it {
      should contain_file('/opt/deployments/another-app-ds.xml')
      .with_content(/.*<password>password<\/password>.*/)
    }
  end
end
