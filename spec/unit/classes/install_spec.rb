require 'spec_helper'
Puppet::Util::Log.level = :debug
Puppet::Util::Log.newdestination(:console)

describe 'jboss::install', :type => :class do
  context "with default parameters" do
    let(:pre_condition) {
      <<-condition
        class { 'jboss':
          source_path => '/tmp',
          source_file => 'jboss.zip',
          install_dir => 'jboss-as',
        }
      condition
    }
    let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }


    context "jboss user and group resources" do
      context "are managed when not declared externally" do
        it {
          should contain_group('jboss')
          .with_ensure('present')
          .with_gid(1506)
        }

        it {
          should contain_user('jboss')
          .with_ensure('present')
          .with_uid(1506)
          .with_home('/export/home/jboss')
          .with_password('$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.')
          .with_gid('jboss')
        }
      end

      context "are not managed when declared externally" do
        let(:pre_condition) { jboss_class = super()
          <<-condition
            user { 'jboss': ensure  => present } ->
            group { 'jboss': ensure  => present } ->
            #{jboss_class}
          condition
        }

        it {
          should_not contain_group('jboss')
          .with_ensure('present')
          .with_gid(1506)
        }

        it {
          should_not contain_user('jboss')
          .with_ensure('present')
          .with_uid(1506)
          .with_gid('jboss')
        }
      end
    end

    context "extracts zip file from default tmp dir into default installation directory" do
      it {
        should contain_exec('unzip file')
        .with_command('/usr/bin/unzip -d /opt/apps /tmp/jboss.zip')
        .with_creates('/opt/apps/jboss-as')
      }
    end

   # context "set jboss user as owner of install_dir" do
   #   it {
   #     should contain_file('/opt/apps/jboss-as')
   #     .with_ensure('directory')
   #     .with_recurse(true)
   #     .with_owner('jboss')
   #     .with_group('jboss')
   #   }
   # end

    context "symlink should not exist if not defined" do
      it {
        should_not contain_file('jboss_symlink')
        .with_ensure('link')
      }
    end
  end

  context "with custom parameters" do
    let(:pre_condition) {
      <<-condition
        class { 'jboss':
          source_path   => '/tmp/nexus',
          source_file   => 'jboss.zip',
          install_dir   => 'jboss-as',
          java_home     => '/opt/java',
          install_path  => '/opt/jboss',
          user          => 'jboss-as',
          group         => 'jboss-group',
          user_home_dir => '/export/home/jboss-as',
          user_password => 'custom_pass',
          sym_link      => '/opt/app/jboss/jboss'
        }
      condition
    }

    context "jboss user and group resources" do
      context "are managed when not declared externally" do
        it {
          should contain_group('jboss-group')
          .with_ensure('present')
          .with_gid(1506)
        }

        it {
          should contain_user('jboss-as')
          .with_ensure('present')
          .with_uid(1506)
          .with_home('/export/home/jboss-as')
          .with_password('custom_pass')
          .with_gid('jboss-group')
        }
      end

      context "are not managed when declared externally" do
        let(:pre_condition) { jboss_class = super()
          <<-condition
            user { 'jboss-as': ensure => present } ->
            group { 'jboss-group': ensure => present } ->
            #{jboss_class}
          condition
        }

        it {
          should_not contain_group('jboss-group')
          .with_ensure('present')
          .with_gid(1506)
        }

        it {
          should_not contain_user('jboss-as')
          .with_ensure('present')
          .with_uid(1506)
          .with_gid('jboss-group')
        }
      end
    end

    context "extracts zip file from custom tmp dir into custom installation directory" do
      it {
        should contain_exec('unzip file')
        .with_command('/usr/bin/unzip -d /opt/jboss /tmp/nexus/jboss.zip')
        .with_creates('/opt/jboss/jboss-as')
      }
    end

    context "create symlink for jboss install" do
      it {
        should contain_file('jboss_symlink')
        .with_ensure('link')
        .with_target('/opt/jboss/jboss-as')
        .with_owner('jboss-as')
        .with_group('jboss-group')
      }
    end
  end
end
