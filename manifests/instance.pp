# == Resource: liferay::instance
#
# === Parameters
#
# [*instance*]  The instance this liferay should be installed in (see tomcat::instance). This instance will be created if not
# defined separatly.
# [*version*]   The version of liferay to install (maven artifact version).
# [*jndi_database*] The jndi datasource used by the instance (defaults to 'jdbc/LiferayPool').
#
# === Variables
#
# === Examples
#
# This will install liferay 6.1.1 in a tomcat instance called liferay_com.
# liferay::instance { 'liferay_com':
#   version     => '6.1.1',
#}
#
# This will install the latest available Liferay CE in a tomcat instance called tomcat_1.
# liferay::instance { 'liferay_com':
#   instance    => 'tomcat_1',
#   version     => 'LATEST',
#}
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define liferay::instance (
    $instance          = $name,
    $version           = 'LATEST',
    $jndi_database     = 'jdbc/LiferayPool',
) {
    include tomcat

    liferay::instance::properties { $name: }

    liferay::instance::dependencies { $name: version => $version }
    
    Liferay::Property {
        instance => $instance,
    }

    if (!defined(Tomcat::Instance[$instance])) {
        tomcat::instance { $instance: }
    }

    liferay::property { "${instance}:jdbc.default.jndi.name":
        key      => 'jdbc.default.jndi.name',
        value    => $jndi_database,
    }

    liferay::property { 'jdbc.default.liferay.pool.provider':
        key      => 'jdbc.default.liferay.pool.provider',
        value    => 'tomcat',
    }

    if (!defined(Tomcat::Jndi::Resource[$instance])) {
        tomcat::jndi::database::hsql { $instance:
            resource_name => $jndi_database,
            instance      => $instance,
            url           => 'jdbc:hsqldb:data/hsql/lportal',
        }
    }

    tomcat::webapp::maven { "${instance}:ROOT":
        webapp     => 'ROOT',
        instance   => $instance,
        groupid    => 'com.liferay.portal',
        artifactid => 'portal-web',
        version    => $version,
    }

    file { "${tomcat::params::home}/${instance}/deploy":
        ensure => directory,
        owner  => $instance,
        group  => $instance,
    }
}