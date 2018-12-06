require 'spec_helper'

describe 'grua::grua_connection' do
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
          grua_certname: 'company.com.br',
          grua_address: '10.10.10.192',
          grua_port: '80',
          grua_token: '8659936f0133c1a7d84d4bf4e32078540675c30e',
        }
      end

      it { is_expected.to compile }
    end
  end
end
