#
class liferay::scripts (
    $version = '6.2',
){
    if ! defined(Package['python-mysql.connector']) {
        package { 'python-mysql.connector': # required for liferay_get_preferences
            ensure => 'present',
        }
    }

    exec { '/usr/local/sbin/gitlab_fetch_folder -u root -g root -m 755 -o /usr/local/sbin minions/liferay/generic':
        unless  =>  '/usr/local/sbin/gitlab_fetch_folder -d -u root -g root -m 755 -o /usr/local/sbin minions/liferay/generic > /dev/null 2>&1',
    }

    exec { '/usr/local/sbin/gitlab_fetch_file -u root -g root -m 644 -o /usr/local/lib/proteon/liferay_generic_include.py libraries/liferay/generic/liferay_generic_include.py':
        unless  =>  '/usr/local/sbin/gitlab_fetch_file -d -u root -g root -m 644 -o /usr/local/lib/proteon/liferay_generic_include.py libraries/liferay/generic/liferay_generic_include.py > /dev/null 2>&1',
    }

    if versioncmp($version, '7.0') >= 0 {
        exec { '/usr/local/sbin/gitlab_fetch_folder -u root -g root -m 755 -o /usr/local/sbin minions/elastic/generic':
            unless  =>  '/usr/local/sbin/gitlab_fetch_folder -d -u root -g root -m 755 -o /usr/local/sbin minions/elastic/generic > /dev/null 2>&1',
        }
    }
}

