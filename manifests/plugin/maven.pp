# == Resource: liferay::plugin::maven
#
# === Parameters
#
# [*instance*]      The instance this plugin should be installed in (see liferay::instance).
# [*groupid*]       The groupid of the plugin to install.
# [*artifactid*]    The artifact of the plugin to install.
# [*version*]       The version of the plugin to install.
#
# === Variables
#
# === Examples
#
# This will install the marketplace plugin in a an instance named liferay_com.
# liferay::instance { 'liferay_com':
#
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
define liferay::plugin::maven ($instance, $groupid, $artifactid, $version) {
    include ::maven
    include ::tomcat

    if (!defined(File["${tomcat::params::home}/${instance}/.plugins"])) {
        file { "${tomcat::params::home}/${instance}/.plugins":
            ensure => directory,
            owner  => 'root',
            group  => 'root',
        }
    }

    maven { "${tomcat::params::home}/${instance}/.plugins/${artifactid}-${version}.war":
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        packaging  => 'war',
        require    => [Liferay::Instance[$instance], Package['maven'], File["${tomcat::params::home}/${instance}/.plugins"]],
        notify     => Exec["${tomcat::params::home}/${instance}/deploy/${artifactid}-${version}.war"],
    }

    exec { "${tomcat::params::home}/${instance}/deploy/${artifactid}-${version}.war":
        command     => "sudo -u ${instance} cp .plugins/${artifactid}-${version}.war deploy/",
        refreshonly => true,
    }
}