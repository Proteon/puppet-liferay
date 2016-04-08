# This resource installs default dependencies for an instance of liferay 7, don't use it directly.
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
define liferay::instance::dependencies7 ($instance = $name, $version) {
  Tomcat::Lib::Maven {
    instance => $instance, }

  tomcat::lib::maven { "${instance}:portal-kernel-2.3.0":
    lib        => "portal-kernel.jar",
    instance   => $instance,
    groupid    => 'com.liferay.portal',
    artifactid => 'com.liferay.portal.kernel',
    version    => '2.3.0',
  }

  tomcat::lib::maven { "${instance}:activation-1.1.1":
    lib        => 'activation.jar',
    groupid    => 'javax.activation',
    artifactid => 'activation',
    version    => '1.1.1',
  }

  tomcat::lib::maven { "${instance}:ccpp-1.0":
    lib        => 'ccpp.jar',
    groupid    => 'javax.ccpp',
    artifactid => 'ccpp',
    version    => '1.0',
  }

  tomcat::lib::maven { "${instance}:com.liferay.osgi.service.tracker.collections-2.0.1":
    lib        => "com.liferay.osgi.service.tracker.collections.jar",
    instance   => $instance,
    groupid    => 'com.liferay',
    artifactid => 'com.liferay.osgi.service.tracker.collections',
    version    => '2.0.1',
  }

  tomcat::lib::maven { "${instance}:com.liferay.registry.api-1.0.3":
    lib        => "com.liferay.registry.api.jar",
    instance   => $instance,
    groupid    => 'com.liferay',
    artifactid => 'com.liferay.registry.api',
    version    => '1.0.3',
  }

  tomcat::lib::maven { "${instance}:jms-1.1-rev-1":
    lib        => 'jms.jar',
    groupid    => 'javax.jms',
    artifactid => 'jms-api',
    version    => '1.1-rev-1',
  }

  tomcat::lib::maven { "${instance}:jta-1.1":
    lib        => 'jta.jar',
    groupid    => 'javax.transaction',
    artifactid => 'jta',
    version    => '1.1',
  }

  tomcat::lib::maven { "${instance}:jutf7-1.0.0":
    lib        => 'jutf7.jar',
    groupid    => 'com.beetstra.jutf7',
    artifactid => 'jutf7',
    version    => '1.0.0',
  }

  tomcat::lib::maven { "${instance}:mail-1.4.7":
    lib        => 'mail.jar',
    groupid    => 'javax.mail',
    artifactid => 'mail',
    version    => '1.4.7',
  }

  tomcat::lib::maven { "${instance}:javax.persistence-2.0.0":
    lib        => 'persistence.jar',
    groupid    => 'org.eclipse.persistence',
    artifactid => 'javax.persistence',
    version    => '2.0.0',
  }

  tomcat::lib::maven { "${instance}:portlet-api-2.1.0":
    lib        => 'portlet-api.jar',
    groupid    => 'javax.portlet',
    artifactid => 'portlet-api',
    version    => '2.1.0',
  }

  #manually added artifact for support-tomcat to maven repo
  tomcat::lib::maven { "${instance}:support-tomcat-${version}":
    lib        => "support-tomcat.jar",
    instance   => $instance,
    groupid    => 'com.liferay.portal',
    artifactid => 'support-tomcat',
    version    => $version,
  }
}
