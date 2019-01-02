# grua::executable
#
# Installs the enc executable and configure the puppet.conf file to use the GRUA instance as the external node classifier
#
class grua::executable {

  file { $grua::exec_path:
    content => epp('grua/puppet_node_classifier.epp',
      {
        master_uuid => $grua::master_zone_id,
        address     => $grua::address,
        port        => $grua::port,
        token       => $grua::token,
      }
    ),
    mode    => '0755',
  }

  augeas { 'master_node_terminus':
    context => "/files${grua::puppetconf_path}",
    changes => [ 'set master/node_terminus exec', ],
  }

  augeas { 'master_external_nodes':
    context => "/files${grua::puppetconf_path}",
    changes => [ "set master/external_nodes ${grua::exec_path}", ],
  }

  $auth_rule = {
              'allow'         => $grua::certname,
              'match-request' => {
                'method' => 'get',
                'path'   => '/puppet/v3/environment_classes/',
                'type'   => 'path'
              },
              'name'          => 'classifier_enviroments_classes',
              'sort-order'    => 500
            }

  hocon_setting { 'rule-classifier_enviroments_classes':
    ensure  => present,
    path    => $grua::auth_path,
    setting => 'authorization.rules',
    value   => $auth_rule,
    type    => array_element,
  }

  if defined(Service['puppetserver']) {
    Hocon_setting['rule-classifier_enviroments_classes']
      ~> Service['puppetserver']
  }

}
