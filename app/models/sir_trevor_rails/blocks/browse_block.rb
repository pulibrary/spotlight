module SirTrevorRails
  module Blocks
    ##
    # Multi-up browse block
    class BrowseBlock < SirTrevorRails::Block
      attr_reader :solr_helper

      def with_solr_helper(solr_helper)
        @solr_helper = solr_helper
      end

      def search_options(id)
        (items.detect { |x| x[:id] == id }) || {}
      end

      def searches
        @searches ||= parent.exhibit.searches.published.where(slug: item_ids).sort { |a, b| order.index(a.id) <=> order.index(b.id) }
      end

      def searches?
        !searches.empty?
      end

      def item_ids
        items.map { |v| v[:id] }
      end

      def items
        item.values.select { |x| x[:display] == 'true' }
      end

      def order
        items.sort_by { |x| x[:weight] }.map { |x| x[:id] }
      end

      def display_item_counts?
        send(:'display-item-counts') == 'true'
      end

      def item_count(category)
        solr_helper.search_results(category.query_params).first['response']['numFound']
      end
    end
  end
end
