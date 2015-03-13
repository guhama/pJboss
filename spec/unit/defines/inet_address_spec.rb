require 'spec_helper'

describe "jboss::bind_address::inet_address", :type => :define do
  let(:title) { 'management' }
  let(:params) {{
    jboss_config: '/path/standalone.xml',
  }}

  let(:hiera_data) { { :jboss_password => '$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.' } }
  context "when :address => '-domain.name'" do
    let(:params) { super().merge(address: '-domain.name') }

    it {
      expect {
        should_not contain_augeas(title)
      }.to raise_error(Puppet::Error, /#{params[:address]} is not a valid domain name, or ip address/)
    }
  end

  context "when :address => '0.0.0.0'" do
    let(:params) { super().merge(address: '0.0.0.0') }

    it {
      should contain_augeas(title)
      .with_incl(params[:jboss_config])
      .with_lens('Xml.lns')
      .with_changes("set //interfaces/interface[#attribute/name='#{title}']/inet-address/#attribute/value '#{params[:address]}'")
      .with_require('Class[Jboss]')
      .with_notify('Service[jboss]')
    }
  end
end
