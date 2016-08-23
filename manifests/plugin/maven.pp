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
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define liferay::plugin::maven (
    $instance, 
    $groupid, 
    $artifactid, 
    $version,
    $show_version = true,
    $postfix = '',
    $extension = 'war',
) {
    include ::maven
    include ::tomcat

    if (!defined(File["${tomcat::params::home}/${instance}/.plugins"])) {
        file { "${tomcat::params::home}/${instance}/.plugins":
            ensure => directory,
            owner  => 'root',
            group  => 'root',
        }
    }

    if $show_version {
        $_version = "-${version}"
    } else {
        $_version = ''
    }

    maven { "${tomcat::params::home}/${instance}/.plugins/${artifactid}${postfix}-${version}.${extension}":
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        packaging  => $extension,
        require    => [Liferay::Instance[$instance], Package['maven'], File["${tomcat::params::home}/${instance}/.plugins"],],
        notify     => Exec["${tomcat::params::home}/${instance}/deploy/${artifactid}${postfix}${_version}.${extension}"],
    }

    exec { "${tomcat::params::home}/${instance}/deploy/${artifactid}${postfix}${_version}.${extension}":
        command     => "/usr/bin/sudo -u ${instance} cp ${tomcat::params::home}/${instance}/.plugins/${artifactid}${postfix}-${version}.${extension} ${tomcat::params::home}/${instance}/deploy/${artifactid}${postfix}${_version}.${extension}",
        refreshonly => true,
    }
}
