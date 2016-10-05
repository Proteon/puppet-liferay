# == Resource: liferay::plugin
#
# === Parameters
#
# [*instance*]  The instance this plugin should be installed in (see liferay::instance).
# [*source*] The source of the file to install (.war).
# [*target*] The target of the file to install (.war), defaults to $name.
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
define liferay::plugin (
    $instance,
    $source = undef,
    $content = undef,
    $target = $name,
    $extention = 'war',
	) {
    include tomcat
    if( $source and $content){
        fail('can\'t specify source and content for a file')
    }
    if (!defined(File["${tomcat::params::home}/${instance}/.plugins"])) {
        file { "${tomcat::params::home}/${instance}/.plugins":
            ensure => directory,
            owner  => 'root',
            group  => 'root',
        }
    }

   $_filename = "${target}.${extention}"

    file { "${tomcat::params::home}/${instance}/.plugins/$_filename":
        source => $source,
        content => $content,
        owner  => 'root',
        group  => 'root',
        notify => Exec["${tomcat::params::home}/${instance}/deploy/${target}.${extention}"],
    }

    exec { "${tomcat::params::home}/${instance}/deploy/${target}.${extention}":
        command     => "/bin/cp '${tomcat::params::home}/${instance}/.plugins/${target}.${extention}' ${tomcat::params::home}/${instance}/deploy/;
                        /bin/chown ${instance}: ${tomcat::params::home}/${instance}/deploy/${target}.${extention}",
        refreshonly => true,
        require     => File["${tomcat::params::home}/${instance}/deploy"],
    }
}
