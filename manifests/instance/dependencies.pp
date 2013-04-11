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

    tomcat::lib::maven { "support-tomcat-${version}":
        instance   => $instance,
        groupid    => 'com.liferay.portal',
        artifactid => 'support-tomcat',
        version    => $version,
    }

    tomcat::lib::maven { "portal-service-${version}":
        instance   => $instance,
        groupid    => 'com.liferay.portal',
        artifactid => 'portal-service',
        version    => $version,
    }

    tomcat::lib::maven { 'activation-1.1.1':
        groupid    => 'javax.activation',
        artifactid => 'activation',
        version    => '1.1.1',
    }

    tomcat::lib::maven { 'ccpp-1.0':
        groupid    => 'javax.ccpp',
        artifactid => 'ccpp',
        version    => '1.0',
    }

    tomcat::lib::maven { 'jms-1.1-rev-1':
        groupid    => 'javax.jms',
        artifactid => 'jms-api',
        version    => '1.1-rev-1',
    }

    tomcat::lib::maven { 'jta-1.1':
        groupid    => 'javax.transaction',
        artifactid => 'jta',
        version    => '1.1',
    }

    tomcat::lib::maven { 'jtds-1.3.0':
        groupid    => 'net.sourceforge.jtds',
        artifactid => 'jtds',
        version    => '1.3.0',
    }

    tomcat::lib::maven { 'jutf7-1.0.0':
        groupid    => 'com.beetstra.jutf7',
        artifactid => 'jutf7',
        version    => '1.0.0',
    }

    tomcat::lib::maven { 'mail-1.4.7':
        groupid    => 'javax.mail',
        artifactid => 'mail',
        version    => '1.4.7',
    }

    tomcat::lib::maven { 'javax.persistence-2.0.0':
        groupid    => 'org.eclipse.persistence',
        artifactid => 'javax.persistence',
        version    => '2.0.0',
    }

    tomcat::lib::maven { 'portlet-api-2.0':
        groupid    => 'javax.portlet',
        artifactid => 'portlet-api',
        version    => '2.0',
    }
}