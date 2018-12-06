# puppet_classifier::grua_connection
#
# Connects the Master CA to the GRUA classifier and syncs the nodes certificates
#
class grua::connection {

  package { 'multipart-post':
    ensure   => present,
    provider => 'puppet_gem',
  }

  puppet_certificate { $grua::certname:
    ensure => present,
  }

  grua_config { $grua::certname:
    ensure               => present,
    master_zone_id       => $grua::master_zone_id,
    signed_cert          => "${grua::puppet_ssl_path}/ca/signed/${grua::certname}.pem",
    private_key          => "${grua::puppet_ssl_path}/private_keys/${grua::certname}.pem",
    puppetserver_address => $grua::puppetserver_address,
    puppetserver_port    => $grua::puppetserver_port,
    puppetdb_address     => $grua::puppetdb_address,
    puppetdb_port        => $grua::puppetdb_port,
    grua_address         => $grua::address,
    grua_port            => $grua::port,
    grua_token           => $grua::token,
    require              => Package['multipart-post'],
  }

}
