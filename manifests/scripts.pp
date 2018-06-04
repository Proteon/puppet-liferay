#
class liferay::scripts (
    $version = '6.2',
){
    package { 'python-mysql.connector': # required for liferay_get_preferences
        ensure => 'present',
    }

    exec { '/usr/local/sbin/gitlab_fetch_folder -u root -g root -m 755 -o /usr/local/sbin minions/liferay/generic':
        unless  =>  '/usr/local/sbin/gitlab_fetch_folder -d -u root -g root -m 755 -o /usr/local/sbin minions/liferay/generic > /dev/null 2>&1',
    }

    if versioncmp($version, '7.0') >= 0 {
        exec { '/usr/local/sbin/gitlab_fetch_folder -u root -g root -m 755 -o /usr/local/sbin minions/elastic/generic':
            unless  =>  '/usr/local/sbin/gitlab_fetch_folder -d -u root -g root -m 755 -o /usr/local/sbin minions/elastic/generic > /dev/null 2>&1',
        }
    }
}
