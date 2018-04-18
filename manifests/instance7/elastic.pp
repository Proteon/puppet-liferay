# sets the configuration for the elasticsearch osgi module in liferay 7
define liferay::instance7::elastic (
  $instance,
  $es_version = '2.4',
  $es_network_bind_host = '127.0.0.1',
  $es_network_host = '127.0.0.1',
  $es_transport_port = '',
  $es_transport_address = '127.0.0.1:9300',
  $es_clustername = 'elasticsearch',
  $es_index_name_prefix = "${instance}-",
  $mode = 'REMOTE',
) {
    file { "/opt/tomcat/sites/${instance}/osgi/configs/com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.cfg":
        owner   => $instance,
        group   => $instance,
        mode    => '0640',
        content => template('liferay/com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.cfg.erb'),
        require => Liferay::Instance7[$instance],
    }

    # If elastic version used is higher than 2.4
    if versioncmp($es_version, '3') > 0 {
        # Blacklist embedded elastic connector because it's only compatible with 2.4 or below
        liferay::instance7::osgi::blacklist { 'com.liferay.portal.search.elasticsearch': }
        liferay::instance7::osgi::blacklist { 'com.liferay.portal.search.elasticsearch.shield': }
        liferay::instance7::osgi::blacklist { 'com.liferay.portal.search.elasticsearch.marvel.web': }

        liferay::plugin::maven { 'elastic6-connector':
            instance    => $instance,
            groupid     => 'com.liferay',
            version     => '1.0.0',
            extension   => 'lpkg',
        }
    }
}

