puppet-liferay
==============

Puppet code for deploying and configuring Liferay in Tomcat

Depencendies:

    'proteon/tomcat', '>=0.1.2'
    'ripienaar/concat', '>=0.2.0'
    'proteon/maven', '>=1.0.1'

Basic usage
-------------------------
To create a Liferay instance

    liferay::instance { 'test_portal': }

This will create all needed resources to have the latest version of Liferay (CE) up and running including a whole tomcat installation, a User and a HSQL database.

A slightly more complicated example

    liferay::instance { 'test_portal_1':
      version       => '6.1.0',
    }

A very complex example using an existing tomcat instance (see Proteon/tomcat::instance)

    tomcat::instance { 'test_portal_2':
      ip_address    => undef,
      http_port     => '18080',
      https_port    => '18443',
      ajp_port      => '18009',
      shutdown_port => '18005',
      scheme        => 'http',
      apr_enabled   => false,
      max_heap      => '1024m',
      min_heap      => '2048m',
      min_perm      => '384m',
      max_perm      => '512m',
      unpack_wars   => false,
      auto_deploy   => false,
    }
    
    tomcat::jndi::database::mysql { 'jdbc/myowndatabasepool':
      instance   => 'test_portal_2',
      database   => 'db_2',
      username   => 'sa',
      password   => 'complexPw13',
      host       => 'dbserver.local',
    }
    
    liferay::instance { 'test_portal_2':
      version       => 'LATEST',
      jndi_database => 'jdbc/myowndatabasepool',
    }

Properties
-------------------------
Add a portal property (portal-ext.properties)

    liferay::property { 'test_portal_2.jdbc.default.jndi.name':
        instance => 'test_portal_2',
        key      => 'jdbc.default.jndi.name',
        value    => 'jdbc/test',
    }

Add a system property (system-ext.properties)

    liferay::property { 'test_portal_3.user.country':
      instance => 'test_portal_3',
      key      => 'user.country',
      value    => 'NL',
      type     => 'system',
    }

Plugins
-------------------------
To install a plugin 
    
    liferay::plugin { 'marketplace':
      instance  => 'test_portal_2',
      source    => 'puppet://application/marketplace-portlet-6.1.1.war'
    }

To install a plugin from a maven repository
    
    liferay::plugin { 'jsf1-portlet':
      instance    => 'test_portal_2',
      artifactid  => 'jsf1-portlet',
      groupid     => 'com.liferay.faces.demos',
      version     => '2.1.1-ga2',
    }
