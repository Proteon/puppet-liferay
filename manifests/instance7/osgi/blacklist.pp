# Define a resource to allow blacklisting of specific OSGi modules
#
# Liferay documentation:
# https://customer.liferay.com/documentation/7.0/admin/-/official_documentation/portal/blacklisting-osgi-modules
#
# === Authors
#
# Alwyn Kik <alwyn@proteon.nl>
#
define liferay::instance7::osgi::blacklist (
    $instance       = 'liferay',
) {
    $config_file    = 'com.liferay.portal.bundle.blacklist.internal.BundleBlacklistConfiguration.config'
    $config_path    = "${tomcat::params::home}/${instance}/osgi/configs/${config_file}"

    concat { $config_path: 
        owner   => $instance,
        group   => $instance,
        mode    => '0640',
        require => File["${tomcat::params::home}/${instance}/osgi"],
    }

    concat::fragment { 'osgi blacklist header':
        target  => $config_path,
        order   => '01',
        content => 'blacklistBundleSymbolicNames=[\n',
    }

    concat::fragment { 'osgi blacklist footer':
        target  => $config_path,
        order   => '99',
        content => ']\n',
    }
}

