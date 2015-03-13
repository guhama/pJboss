require 'spec_helper'

describe "jboss::https", :type => :define do
  let(:title) { 'https' }
  let(:jboss_config) { '/path/to/standalone.xml' }

  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  context "when :password => undef" do
    it {
      expect {
        should have_resource_count(0)
      }.to raise_error(Puppet::Error, /:password parameter must be provided/)
    }
  end

  context "when :certificate_key_file => undef" do
    let(:params) {{
      :password  => 'le password',
    }}

    it {
      expect {
        should have_resource_count(0)
      }.to raise_error(Puppet::Error, /:certificate_key_file parameter must be provided/)
    }
  end

  context "when :config_file => undef" do
    let(:params) {{
      :password             => 'le password',
      :certificate_key_file => '/path/to/file'
    }}

    it {
      expect {
        should have_resource_count(0)
      }.to raise_error(Puppet::Error, /:config_file parameter must be provided/)
    }
  end

  context "when all required parameters are provided" do
    let(:params) {{
      :password             => 'le password',
      :certificate_key_file => '/key/file/path',
      :config_file          => jboss_config,
    }}

    https_connector = 'server/profile/subsystem[22]/connector[2]'
    https = "#{https_connector}/#attribute"
    ssl = "#{https_connector}/ssl/#attribute"
    non_valid_augeas_xml = '"<?xml version=\'1.0\' encoding=\'UTF-8\'?>"'

    it {
      should contain_augeas('[https] config')
      .with_incl(jboss_config)
      .with_lens('Xml.lns')
      .with_changes([
        "set #{https}/name               'https'",
        "set #{https}/protocol           'HTTP/1.1'",
        "set #{https}/scheme             'HTTPS'",
        "set #{https}/socket-binding     'https'",
        "set #{https}/enable-lookups     'false'",
        "set #{https}/secure             'true'",
        "set #{ssl}/name                 'ssl'",
        "set #{ssl}/password             'le password'",
        "set #{ssl}/certificate-key-file '/key/file/path'",
        "set #{ssl}/protocol             'TLSv1'",
        "set #{ssl}/verify-client        'false'",
      ])
      #.with_onlyif('match #{https}/name')
    }

    it {
      should contain_exec('[https] filter standalone.xml')
      .with_command("/bin/sed -i 1d #{jboss_config}")
      .with_onlyif("/bin/grep -Fxq #{non_valid_augeas_xml} #{jboss_config}")
    }
  end
end
