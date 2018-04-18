#
define liferay::instance7::osgi::blacklist::entry (
    $instance       = 'liferay',
    $module_name    = $name,
) {
    $config_path    = "${tomcat::params::home}/${instance}/osgi/configs"
    $config_file    = 'com.liferay.portal.bundle.blacklist.internal.BundleBlacklistConfiguration.config'

    concat::fragment { $name:
        target  => "${config_path}/${config_file}",
        order   => 10,
        content => "    \"${module_name}\"\n",
    }
}

