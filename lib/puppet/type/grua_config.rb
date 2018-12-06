Puppet::Type.newtype(:grua_config) do
  @doc = %q(
    Register a puppet server in GRUA

    Example:

    grua_config { 'puppet-homol01':
      ensure               => present,
      master_zone_id       => 'aced7ddb-8127-4061-aad6-020f9e1b2333',
      signed_cert          => '/etc/puppetlabs/puppet/ssl/ca/signed/classifier.company.com.br.pem',
      private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/classifier.company.com.br.pem',
      puppetserver_address => "${facts['networking']['ip']}",
      puppetserver_port    => 8140,
      puppetdb_address     => "${facts['networking']['ip']}",
      puppetdb_port        => 8080,
      grua_address         => '10.10.10.190',
      grua_port            => '81',
      grua_token           => '8659936f0133c1a7d84d4bf4e32078540675c30e'
    }
  )

  ensurable

  newparam(:name) do
    desc 'A title for the config'
  end

  newproperty(:master_zone_id) do
    desc 'The master uuid in the GRUA classifier (get one by creating a new master)'

    validate do |value|
      unless value =~ /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/
        raise ArgumentError, "#{value} is not a valid uuid v4"
      end
    end
  end

  newproperty(:signed_cert) do
    desc 'The path to the signed cert used by the GRUA classifier to fetch the classes'
  end

  newproperty(:private_key) do
    desc 'The path to the private key used by the GRUA classifier to fetch the classes'
  end

  newproperty(:puppetserver_address) do
    desc 'The GRUA classifier will use this address to access the /puppet/v3/environment_classes/ endpoint'
  end

  newproperty(:puppetserver_port) do
    desc 'The GRUA classifier will use this port to access the /puppet/v3/environment_classes/ endpoint'
  end

  newproperty(:puppetdb_address) do
    desc 'The GRUA classifier will use this address to request data from PuppetDB endpoints'
  end

  newproperty(:puppetdb_port) do
    desc 'The GRUA classifier will use this port to request data from PuppetDB endpoints'
  end

  newproperty(:grua_address) do
    desc 'This node will communicate with the GRUA classifier api in this address'
  end

  newproperty(:grua_port) do
    desc 'This node will communicate with the GRUA classifier api in this port'
  end

  newproperty(:grua_token) do
    desc 'This node will authenticate in the GRUA classifier api with this token'
  end
end
