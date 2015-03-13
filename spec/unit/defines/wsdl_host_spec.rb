require 'spec_helper'

describe "jboss::bind_address::wsdl_host", :type => :define do
  let(:title) { '192.168.57.100' }
  let(:params) {{
    jboss_config: '/path/file.xml',
  }}

  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  context "when :address => '-domain.name'" do
    let(:params) { super().merge(address: '-domain.name') }
    it {
      expect {
        should_not contain_augeas("wsdl-host #{params[:address]}")
      }.to raise_error(Puppet::Error, /#{params[:address]} is not a valid domain name, or ip address/)
    }
  end

  context "when :address parameter is not provided, it defaults to :title" do
    it {
      should contain_augeas("wsdl-host #{title}")
      .with_incl(params[:jboss_config])
      .with_lens('Xml.lns')
      .with_notify('Service[jboss]')
      .with_require('Class[Jboss]')
      .with_changes("set //subsystem[#attribute/xmlns='urn:jboss:domain:webservices:1.2']/wsdl-host/#text '#{title}'")
    }
  end

  context "when :address => '0.0.0.0'" do
    let(:params) { super().merge(address: '0.0.0.0') }
    it {
      should contain_augeas("wsdl-host #{params[:address]}")
      .with_incl(params[:jboss_config])
      .with_lens('Xml.lns')
      .with_notify('Service[jboss]')
      .with_require('Class[Jboss]')
      .with_changes("set //subsystem[#attribute/xmlns='urn:jboss:domain:webservices:1.2']/wsdl-host/#text '#{params[:address]}'")
    }
  end
end
