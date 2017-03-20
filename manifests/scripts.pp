#
class liferay::scripts (
){
    exec { '/usr/local/sbin/gitlab_fetch_folder -u root -g root -m 755 -o /usr/local/sbin minions/liferay/generic':
        unless  =>  '/bin/ls -1 /usr/local/sbin|/bin/grep liferay_ > /dev/null 2>&1',
    }
}
