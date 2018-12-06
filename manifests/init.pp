# Class grua
#
# Configures the Grua as an External Node Classifier (ENC), and syncs the certificates if the PuppetServer is also the CA
#
# @param [String] master_zone_id The puppetserver uuid registered in GRUA
# @param [String] address Host or ip of the classifier instance
# @param [String] port Port to connect to the classifier API
# @param [String] certname The certname used by the classifier to make authenticated calls
# @param [String] token Token to authenticate to the classifier API
# @param [String] auth_path Path to the auth.conf file. Default is /etc/puppetlabs/puppetserver/conf.d/auth.conf
# @param [String] exec_path Path to the external classifier executable. Default is /usr/local/bin/puppet_node_grua
# @param [String] puppetconf_path Path to the puppet.conf file. Default is /etc/puppetlabs/puppet/puppet.conf
# @param [Boolean] is_ca Whether the PuppetServer is also the CA, so the module will configure its connection with Grua. Default is false
# @param [String] puppet_ssl_path The Puppet CA ssl files path. Default: /etc/puppetlabs/puppet/ssl/
# @param [String] puppetserver_address Host or ip used by GRUA to access the puppetserver. Default is facts['networking']['ip']
# @param [Integer] puppetserver_port Port to connect to the puppetserver API
# @param [String] puppetdb_address Host or ip used by GRUA to access the puppetdb. Default is facts['networking']['ip']
# @param [Integer] puppetdb_port Port to connect to the puppetdb API

class grua (
  String $master_zone_id,
  String $address,
  Integer[0,65535] $port,
  String $token,
  String $certname,
  String $auth_path,
  String $exec_path,
  String $puppetconf_path,
  Boolean $is_ca,
  String $puppet_ssl_path,
  String $puppetserver_address,
  Integer[1024,65535] $puppetserver_port,
  String $puppetdb_address,
  Integer[1024,65535] $puppetdb_port,
) {

  include grua::executable

  if $is_ca {
    include grua::connection
  }

}
