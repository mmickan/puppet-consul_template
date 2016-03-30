require 'spec_helper_acceptance'

describe 'consul_template class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'consul_template': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/usr/local/bin/consul-template') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to '/opt/staging/consul-template-0.14.0/consul-template' }
    end

    describe service('consul-template') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
