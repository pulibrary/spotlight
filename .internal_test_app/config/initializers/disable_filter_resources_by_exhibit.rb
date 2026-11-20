# Setting this to false when running tests so that we don't have to set up
# exhibit specific solr documents for tests that don't use the default exhibit.
Spotlight::Engine.config.filter_resources_by_exhibit = false
