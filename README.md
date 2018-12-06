
# grua

Module to connect puppet servers with the GRUA classifier.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with grua](#setup)
    * [What grua affects](#what-puppet_classifier-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with grua](#beginning-with-puppet_classifier)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Description

This module connects Puppet Servers with the GRUA classifier.

## Setup

### What grua affects

This module creates an executable that gets the output from the External Node Classifier (ENC), containing the nodes classification, configures the puppet.conf file to use the GRUA instance as an ENC. And the auth.conf file authorizing the GRUA to get info about the classes present on the environments.

It also syncs the nodes certificates if the Puppet Server that is being connected has the CA enabled.

### Setup Requirements

It's required to use the classifier interface to register a new master and get it's UUID.

### Beginning with grua

```puppet
class { 'grua::grua_connection':
  master_zone_id => 'b30803af-8b6c-4b25-885e-6f299e9a9d55',
  grua_certname  => 'classifier-prod.company.com.br.pem',
  grua_address   => '10.10.10.192',
  grua_port      => '80'
}
```

## Usage

On a Master Compiler (CA disabled):

```puppet
class { 'grua':
  master_zone_id => 'b30803af-8b6c-4b25-885e-6f299e9a9d55',
  certname       => 'classifier-prod.company.com.br',
  address        => '10.10.10.192',
  port           => 80,
  token          => '8659936f0133c1a7d84d4bf4e32078540675c30e',
}
```

On a monolithic installation:

```puppet
class { 'grua':
  master_zone_id => 'b30803af-8b6c-4b25-885e-6f299e9a9d55',
  certname       => 'classifier-prod.company.com.br',
  address        => '10.10.10.192',
  port           => 80,
  token          => '8659936f0133c1a7d84d4bf4e32078540675c30e',
  is_ca          => true,
}
```

On a Master CA in a split installation:

```puppet
class { 'grua':
  master_zone_id       => 'b30803af-8b6c-4b25-885e-6f299e9a9d55',
  certname             => 'classifier-prod.company.com.br',
  address              => '10.10.10.192',
  port                 => 80,
  token                => '8659936f0133c1a7d84d4bf4e32078540675c30e',
  is_ca                => true,
  puppetserver_address => '10.10.10.192', # Or just let the default value, that is the local IP
  puppetserver_port    => 8140,
  puppetdb_address     => '10.10.10.193',
  puppetdb_port        => 8080,
}
```

Using with hiera:

In your Puppet class:

```puppet
include grua::grua_connection
include grua::executable
```

In your Hiera file:

```yaml
grua::master_zone_id: 'b30803af-8b6c-4b25-885e-6f299e9a9d55'
grua::address: '10.10.10.192'
grua::port: 80
grua::token: '8659936f0133c1a7d84d4bf4e32078540675c30e'
grua::certname: 'classifier-prod.company.com.br.pem'
grua::auth_path: '/etc/puppetlabs/puppetserver/conf.d/auth.conf'
grua::exec_path: '/usr/local/bin/puppet_node_classifier'
grua::puppetconf_path: '/etc/puppetlabs/puppet/puppet.conf'
grua::is_ca: true
grua::puppet_ssl_path: '/etc/puppetlabs/puppet/ssl'
grua::puppetserver_address: $::networking['ip']
grua::puppetserver_port: 8140
grua::puppetdb_address: $::networking['ip']
grua::puppetdb_port: 8080
```

## Reference

### Classes

#### grua

#### `master_zone_id`

**Type:** String

The puppetserver uuid registered on GRUA. You will get one by creating a new master on GRUA.

#### `address`

**Type:** String

Host or ip of the GRUA instance

#### `port`

**Type:** Integer

Port to connect to the GRUA API

#### `token`

**Type:** String

Token to authenticate to the GRUA API

#### `auth_path`

**Type:** String

Path to the auth.conf file. Default is `/etc/puppetlabs/puppetserver/conf.d/auth.conf`

#### `exec_path`

**Type:** String

Path to the external GRUA executable. Default is `/usr/local/bin/puppet_node_classifier`

#### `puppetconf_path`

**Type:** String

Path to the puppet.conf file. Default is `/etc/puppetlabs/puppet/puppet.conf`

#### `is_ca`

**Type:** Boolean

Whether the Master that is being configured has the CA enabled, so the module will create a connection that lets the GRUA classifier access and syncs the nodes certificates. Default is `false`

#### `puppet_ssl_path` (Optional)

**Type:** String

The Puppet CA ssl files path. Only used when the parameter `is_ca` is `true`. Default is `/etc/puppetlabs/puppet/ssl`

#### `puppetserver_address` (Optional)

**Type:** String

Host or ip used by GRUA to access the puppetserver. Only used when the parameter `is_ca` is `true`.  Default is `facts['networking']['ip']`

#### `puppetserver_port` (Optional)

**Type:** Integer

Port to connect to the puppetserver API. Only used when the parameter `is_ca` is `true`. Default is `8140`

#### `puppetdb_address` (Optional)

**Type:** String

Host or ip used by GRUA to access the puppetdb. Only used when the parameter `is_ca` is `true`. Default is `facts['networking']['ip']`

#### `puppetdb_port` (Optional)

**Type:** Integer

Port to connect to the puppetdb API. Only used when the parameter `is_ca` is `true`. Default is `8080`.

### Custom Types and Providers

### `classifier_config`

Registers a Puppet Server (that has the CA enabled) on GRUA. Checks if the GRUA instance already has the server's certificates, and uploads it if needed, using the built-in GRUA API.

## Release Notes/Contributors/Etc.

### Author

Oscar Esgalha (oscar at instruct dot com dot br)

### Contributors

Igor Oliveira (igor at instruct dot com dot br)
