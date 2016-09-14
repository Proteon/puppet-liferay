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
define liferay::property (
    $instance,
    $web_id = undef,
    $type = 'portal',
    $key = $name,
    $value
) {
    include tomcat
    
    if !($type in ['portal', 'portlet', 'system']) {
        fail("The property type must be one of 'portal', 'portlet' or 'system', but was '${type}'")
    }

    if ($web_id != undef) and ($type != 'portal') {
        fail('When setting a property for a portal instance by passing a web_id, the type MUST be portal')
    }

    if ($web_id != undef) {
        $_web_id = $web_id

        ensure_resource('concat', "${tomcat::params::home}/${instance}/tomcat/lib/${type}-${_web_id}.properties", {
            owner => $instance,
            group => $instance,
            mode  => '0640',
            require => File["${tomcat::params::home}/${instance}/tomcat/lib"],
        })

        ensure_resource('concat::fragment', "${instance} ${type}-${_web_id}.properties header", {
            target  => "${tomcat::params::home}/${instance}/tomcat/lib/${type}-${_web_id}.properties",
            order   => 00,
            content => "# Managed by puppet\n",
        })

    } else {
        $_web_id = 'ext'
    }

    concat::fragment { $name:
        target  => "${tomcat::params::home}/${instance}/tomcat/lib/${type}-${_web_id}.properties",
        order   => 01,
        content => "${key}=${value}\n",
        notify  => Tomcat::Service[$instance],
    }
}
