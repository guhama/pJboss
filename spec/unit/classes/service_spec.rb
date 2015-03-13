require 'spec_helper'

describe 'jboss::service', :type => :class do
  context "with default parameters" do
    let(:facts) {{ :fqdn => 'node.domain.com' }}
    let(:pre_condition) {
      <<-condition
        class { 'jboss':
          source_path => 'puppet:///mount_point/jboss',
          source_file => 'jboss.zip',
          install_dir => 'jboss-as',
        }
      condition
    }

    let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }

    context "creates jboss init script" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_ensure('file')
        .with_mode('0755')
      }
    end


    context "uses fqdn fact as bind address" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*standalone\.sh' -b=node\.domain\.com.*/)
      }
    end

    context "properly assigns script variables" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JAVA_OPTS=''.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JAVA_HOME=\/usr.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_HOME=\/opt\/apps\/jboss-as.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_USER=jboss.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_PIDFILE=\/var\/run\/jboss\/jboss.pid.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_CONSOLE_LOG=\/opt\/app\/jboss\/logs\/jboss.log.*/)
      }
    end

    context "directory for storing jboss.pid file is present" do
      it {
        should contain_file('/var/run/jboss')
        .with_ensure('directory')
        .with_owner('jboss')
        .with_group('jboss')
      }
    end

    context "directory for storing jboss.log file is present" do
      it {
        should contain_file('/opt/app/jboss/logs')
        .with_ensure('directory')
        .with_owner('jboss')
        .with_group('jboss')
      }
    end

    context "enables jboss to run as a service" do
      it {
        should contain_service('jboss')
        .with_ensure('running')
        .with_enable(true)
      }
    end
  end

  context "with custom parameters" do
    let(:pre_condition) {
      <<-condition
        class { 'jboss':
          source_path    => 'puppet:///mount_point/jboss',
          source_file    => 'jboss.zip',
          install_path   => '/opt/custom/apps',
          install_dir    => 'jboss-as',
          user           => 'jboss-user',
          group          => 'jboss-group',
          bind_address   => 'custom.node.domain.com',
          enable_service => false,
          java_home      => '/opt/app/java',
          java_opts      => '-Xms1303m',
          pid_path       => '/custom/run/jboss',
          log_path       => '/custom/log/jboss',
        }
      condition
    }

    let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
    context "creates jboss init script" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_ensure('file')
        .with_mode('0755')
      }
    end

    context "uses fqdn fact as bind address" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*standalone\.sh' -b=custom\.node\.domain\.com.*/)
      }
    end

    context "properly assigns script variables" do
      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JAVA_OPTS='-Xms1303m'.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JAVA_HOME=\/opt\/app\/java.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_HOME=\/opt\/custom\/apps\/jboss-as.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_USER=jboss-user.*/)
      }

      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_PIDFILE=\/custom\/run\/jboss\/jboss.pid.*/)
      }


      it {
        should contain_file('/etc/init.d/jboss')
        .with_content(/.*JBOSS_CONSOLE_LOG=\/custom\/log\/jboss\/jboss.log.*/)
      }
    end

    context "directory for storing jboss.pid file is present" do
      it {
        should contain_file('/custom/run/jboss')
        .with_ensure('directory')
        .with_owner('jboss-user')
        .with_group('jboss-group')
      }
    end

    context "directory for storing jboss.log file is present" do
      it {
        should contain_file('/custom/log/jboss')
        .with_ensure('directory')
        .with_owner('jboss-user')
        .with_group('jboss-group')
      }
    end

    context "disables jboss service" do
      it {
        should contain_service('jboss')
        .with_ensure('running')
        .with_enable(false)
      }
    end
  end
end
