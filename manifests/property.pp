# This resource installs default *-ext.properties resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define liferay::property ($instance, $type = 'portal', $key, $value) {
    concat::fragment { "${name}: ${key}=${value}":
        target  => "${tomcat::params::home}/${instance}/tomcat/lib/${type}-ext.properties",
        order   => 01,
        content => "${key}=${value}\n",
    }
}
