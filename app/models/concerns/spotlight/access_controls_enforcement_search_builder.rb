module Spotlight
  # Enforce exhibit visibility for index queries
  module AccessControlsEnforcementSearchBuilder
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:apply_permissive_visibility_filter, :apply_exhibit_resources_filter]
    end

    def apply_permissive_visibility_filter(solr_params)
      return unless current_exhibit
      return if scope.respond_to?(:can?) && scope.can?(:curate, current_exhibit) && !blacklight_params[:public]

      solr_params.append_filter_query "-#{Spotlight::SolrDocument.visibility_field(current_exhibit)}:false"
    end

    def apply_exhibit_resources_filter(solr_params)
      return unless Spotlight::Engine.config.filter_resources_by_exhibit && current_exhibit

      current_exhibit.solr_data.each do |facet_field, values|
        Array(values).each do |value|
          solr_params.append_filter_query send(:facet_value_to_fq_string, facet_field, value)
        end
      end
    end

    private

    def current_exhibit
      scope.current_exhibit
    end
  end
end
