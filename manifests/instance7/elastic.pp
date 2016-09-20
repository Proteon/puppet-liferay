# sets the configuration for the elasticsearch osgi module in liferay 7
define liferay::instance7::elastic (
  $instance,
  $es_network_bind_host = '127.0.0.1',
  $es_network_host = '127.0.0.1',
  $es_transport_port = '',
  $es_transport_address = '127.0.0.1:9300',
  $es_clustername = 'elasticsearch',
  $es_index_name_prefix = "${instance}-",
  $mode = 'REMOTE',
) {
    file { '/opt/tomcat/sites/liferay/osgi/configs/com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.cfg':
        owner   => $instance,
        group   => $instance,
        mode    => '0640',
        content => template('liferay/com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.cfg.erb'),
        require => Liferay::Instance7[$instance],
    }
}

