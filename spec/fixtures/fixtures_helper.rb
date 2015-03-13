module PuppetFixtures
  def self.fixtures_path
    "#{File.expand_path File.dirname(__FILE__)}"
  end

  def self.manifests_path
    "#{fixtures_path}/manifests"
  end

  def self.modules_path
    "#{fixtures_path}/modules"
  end

  def self.files_path
    "#{fixtures_path}/files"
  end

  def load_manifest(manifest)
    File.read(manifest)
  end

  module Manifests
    def self.manifests_path
      PuppetFixtures.manifests_path
    end

    def self.jboss
      load_manifest("#{manifests_path}/jboss.pp")
    end

    def self.jboss_datasource
      load_manifest("#{manifests_path}/jboss__datasource.pp")
    end

    def self.jboss_datasource_driver
      load_manifest("#{manifests_path}/jboss__datasource_driver.pp")
    end

    def self.jboss_https
      load_manifest("#{manifests_path}/jboss__https.pp")
    end
  end
end
