# == Resource: liferay::instance7
# Requires access to the liferay CE maven repo or our proxy of it and access to our third party maven repo
#
# Note: the first time the instance is created, if you use the (default) JNDI connection,
# and version 6.1.1, some error messages will be displayed in the log.
# This is a known bug: http://issues.liferay.com/browse/LPS-29672
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
# This will install liferay 7.0.0 in a tomcat instance called liferay_com.
# liferay::instance { 'liferay_com':
#   version     => '7.0.0',
#}
#
# This will install the latest available Liferay CE 7 in a tomcat instance called tomcat_1.
# liferay::instance { 'liferay_com':
#   instance    => 'tomcat_1',
#   version     => 'LATEST',
#}
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
# Simon Smit <simon@firelay.com>
#
# === Copyright
#
# Copyright 2016 Proteon.
#
define liferay::instance7 (
  $version,
  $instance = $name,
  $jndi_database = 'jdbc/LiferayPool',
  $osgi_console_port = '11311',
  $osgi_dir = '/osgi',
) {
   if ! (versioncmp($version, '7.0') >= 0 ) {
    fail("unsupported version for liferay 7 for ${name}: ${version}")
  }
#  include java
  include tomcat
  $_osgi_fs_dir = "${tomcat::params::home}/${instance}${osgi_dir}"
  $_osgi_dir_prop = "\${liferay.home}${osgi_dir}"
  $_tomcat_lib_ext = "${tomcat::params::home}/${instance}/tomcat/lib/ext"

  $java_version = 'oracle_1_8_0'

  liferay::instance::properties { $name: }

  Liferay::Property {
    instance => $instance, }

  if (!defined(Tomcat::Instance[$instance])) {
    tomcat::instance { $instance: java_version => $java_version }
  }

  liferay::property { "${instance}:jdbc.default.jndi.name":
    key   => 'jdbc.default.jndi.name',
    value => $jndi_database,
  }

  liferay::property { "${instance}:module.framework.base.dir":
      key   => 'module.framework.base.dir',
      value => "${_osgi_dir_prop}",
  }
  liferay::property { "${instance}:module.framework.properties.osgi.console":
    key   => 'module.framework.properties.osgi.console',
    value => "localhost:${osgi_console_port}",
  }

  # Install liferay 7 dependencies
  # manually created and added zip file to maven repo
  maven { "/tmp/dependencies-${instance}-${version}.zip":
    groupid    => 'com.liferay.dependencies',
    artifactid => 'liferay-dependencies',
    version    => $version,
    packaging  => 'zip',
    require    => [Package['maven']],
    notify     => Exec["install-liferay-dependencies-${instance}"],
  }

  exec { "install-liferay-dependencies-${instance}":
    command => "/usr/bin/unzip -o /tmp/dependencies-${instance}-${version}.zip -d ${_tomcat_lib_ext} && chown ${instance}:${instance} -R ${_tomcat_lib_ext}",
    creates => $_tomcat_lib_ext,
    require => Tomcat::Instance["${instance}"],
  }

  # install liferay 7 osgi bundles
  # manually created and added zip file to maven repo
  maven { "/tmp/liferay-osgi-bundle-${instance}-${version}.zip":
    groupid    => 'com.liferay.osgi',
    artifactid => 'liferay-osgi',
    version    => $version,
    packaging  => 'zip',
    require    => [Package['maven']],
    notify     => Exec["install-osgi-bundles-${instance}"],
  }

  exec { "install-osgi-bundles-${instance}":
    command  => "/usr/bin/unzip -o /tmp/liferay-osgi-bundle-${instance}-${version} -d ${_osgi_fs_dir} && chown ${instance}:${instance} -R ${_osgi_fs_dir}",
    creates  => "${_osgi_fs_dir}/core",
    require  => Tomcat::Instance["${instance}"],
  }

##manually added war to maven repo..
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

  file { "${tomcat::params::home}/${instance}/logs":
    ensure => directory,
    owner  => $instance,
    group  => $instance,
  }
}

