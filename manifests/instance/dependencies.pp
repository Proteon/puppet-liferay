# This resource installs default dependencies for an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define liferay::instance::dependencies ($instance = $name, $version) {
    Tomcat::Lib::Maven {
        instance => $instance, }

    tomcat::lib::maven { "${instance}:support-tomcat-${version}":
        lib        => "support-tomcat-${version}.jar",
        instance   => $instance,
        groupid    => 'com.liferay.portal',
        artifactid => 'support-tomcat',
        version    => $version,
    }

    tomcat::lib::maven { "${instance}:portal-service-${version}":
        lib        => "portal-service-${version}.jar",
        instance   => $instance,
        groupid    => 'com.liferay.portal',
        artifactid => 'portal-service',
        version    => $version,
    }

    tomcat::lib::maven { "${instance}:activation-1.1.1":
        lib        => 'activation-1.1.1.jar',
        groupid    => 'javax.activation',
        artifactid => 'activation',
        version    => '1.1.1',
    }

    tomcat::lib::maven { "${instance}:ccpp-1.0":
        lib        => 'ccpp-1.0.jar',
        groupid    => 'javax.ccpp',
        artifactid => 'ccpp',
        version    => '1.0',
    }

    tomcat::lib::maven { "${instance}:jms-1.1-rev-1":
        lib        => 'jms-1.1-rev-1.jar',
        groupid    => 'javax.jms',
        artifactid => 'jms-api',
        version    => '1.1-rev-1',
    }

    tomcat::lib::maven { "${instance}:jta-1.1":
        lib        => 'jta-1.1.jar',
        groupid    => 'javax.transaction',
        artifactid => 'jta',
        version    => '1.1',
    }

    tomcat::lib::maven { "${instance}:jtds-1.3.0":
        lib        => 'jtds-1.3.0.jar',
        groupid    => 'net.sourceforge.jtds',
        artifactid => 'jtds',
        version    => '1.3.0',
    }

    tomcat::lib::maven { "${instance}:jutf7-1.0.0":
        lib        => 'jutf7-1.0.0.jar',
        groupid    => 'com.beetstra.jutf7',
        artifactid => 'jutf7',
        version    => '1.0.0',
    }

    tomcat::lib::maven { "${instance}:mail-1.4.7":
        lib        => 'mail-1.4.7.jar',
        groupid    => 'javax.mail',
        artifactid => 'mail',
        version    => '1.4.7',
    }

    tomcat::lib::maven { "${instance}:javax.persistence-2.0.0":
        lib        => 'javax.persistence-2.0.0.jar',
        groupid    => 'org.eclipse.persistence',
        artifactid => 'javax.persistence',
        version    => '2.0.0',
    }

    tomcat::lib::maven { "${instance}:portlet-api-2.0":
        lib        => 'portlet-api-2.0.jar',
        groupid    => 'javax.portlet',
        artifactid => 'portlet-api',
        version    => '2.0',
    }
}
