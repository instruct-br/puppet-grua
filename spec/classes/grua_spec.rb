require 'spec_helper'

describe 'grua' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          'networking' => { 'ip' => '10.10.10.193' },
        )
      end
      let(:params) do
        {
          master_zone_id: 'b8d3fe08-58e1-4db9-8747-5956364febac',
          certname: 'company.com.br',
          address: '10.10.10.192',
          port: 80,
          token: '8659936f0133c1a7d84d4bf4e32078540675c30e',
          auth_path: '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
          exec_path: '/usr/local/bin/puppet_node_classifier',
          puppetconf_path: '/etc/puppetlabs/puppet/puppet.conf',
          is_ca: false,
          puppet_ssl_path: '/etc/puppetlabs/puppet/ssl',
          puppetserver_address: 'puppet.test',
          puppetserver_port: 8140,
          puppetdb_address: '10.10.10.192',
          puppetdb_port: 8080,
        }
      end

      it { is_expected.to compile }
    end
  end
end
