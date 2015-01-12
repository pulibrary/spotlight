module Spotlight
  class Resources::Upload < Spotlight::Resource
    mount_uploader :url, Spotlight::ItemUploader

    def to_solr
      store_url! # so that #url doesn't return the tmp directory
      to_solr_hash
    end

    def self.fields(exhibit)
      @fields ||= self.new(exhibit: exhibit).configured_fields.keys
    end

    def configured_fields
      @configured_fields ||= {
        title: {solr_field: exhibit.blacklight_config.index.title_field}
      }
    end

    private
    def to_solr_hash
      solr_hash = {
        ::SolrDocument.unique_key.to_sym => compound_id,
        exhibit.blacklight_config.index.full_image_field => url.url
      }
      Spotlight::ItemUploader.configured_versions.each do |config|
        solr_hash[exhibit.blacklight_config.index.send(config[:blacklight_config_field])] = url.send(config[:version]).url
      end
      configured_fields.each do |key, config|
        solr_hash[config[:solr_field]] = data[key]
      end
      solr_hash
    end

    def compound_id
      "#{exhibit_id}-#{id}"
    end
  end
end