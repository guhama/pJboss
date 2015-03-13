require 'serverspec_helper'

describe "JBoss" do
  context "process" do
    let(:subject) { command('ps aux | grep org.jboss.as.standalone') }

    context "uses JAVA_OPTS" do
      its(:stdout) { should match /.*-Xms1303m -Xmx30g.*/ }
    end

    context "runs as 'le_jboss' user" do
      its(:stdout) { should match /^le_jboss\s.*/ }
    end

    context "runs as a service" do
      let(:subject) { service('jboss') }

      it { should be_enabled }
      it { should be_running }
    end
  end

  context "has myapp-ds.xml datasource deployed" do
    let(:subject) { file('/opt/jboss/jboss/standalone/deployments/myapp-ds.xml.deployed') }

    it { should be_a_file }
  end

  context "has ojdbc6g.jar driver deployed" do
    let(:subject) { file('/opt/jboss/jboss-eap-6.1/standalone/deployments/ojdbc6g.jar.deployed') }

    it { should be_a_file }
  end
end
