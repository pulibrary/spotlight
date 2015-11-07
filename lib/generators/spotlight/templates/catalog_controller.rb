##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = 'full_title_tesim'

    config.add_search_field 'all_fields', label: 'All fields'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'

    config.add_field_configuration_to_solr_request!
  end
end
