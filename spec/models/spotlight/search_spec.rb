# frozen_string_literal: true

RSpec.describe Spotlight::Search, type: :model do
  subject { exhibit.searches.build(title: 'Search', query_params:) }

  let(:exhibit) { FactoryBot.create(:exhibit) }

  let(:query_params) { { 'f' => { 'genre_ssim' => ['map'] } } }

  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:document) do
    SolrDocument.new(id: 'dq287tq6352',
                     blacklight_config.index.title_field => 'title')
  end

  describe 'for a search matching all items' do
    let(:query_params) { {} }

    it 'has items' do
      # Add some fuzziness to this. Running locally it should be 55 but in some
      # CI environments, spec/features/add_items_spec.rb will end up adding new
      # records and cannot ensure deletion of them.
      expect(subject.documents.size).to be_within(1).of(55)
    end
  end

  describe 'default_scope' do
    let!(:page1) { FactoryBot.create(:search, weight: 5, published: true) }
    let!(:page2) { FactoryBot.create(:search, weight: 1, published: true) }
    let!(:page3) { FactoryBot.create(:search, weight: 10, published: true) }

    it 'orders by weight' do
      expect(described_class.published.map(&:weight)).to eq [1, 5, 10]
    end
  end

  describe '.unpublished' do
    let!(:search1) { FactoryBot.create(:search, published: true) }
    let!(:search2) { FactoryBot.create(:search, published: false) }
    let!(:search3) { FactoryBot.create(:search, published: nil) }

    it 'accounts for nil and false values' do
      expect(described_class.unpublished.count).to eq 5
    end
  end

  describe '#slug' do
    let(:search) { FactoryBot.create(:search) }

    it 'gets a default slug' do
      expect(search.slug).not_to be_blank
    end

    it 'is updated when the title changes' do
      search.update(title: 'abc')
      expect(search.slug).to eq 'abc'
    end

    context 'with a custom slug' do
      let(:search) { FactoryBot.create(:search, slug: 'xyz') }

      it 'gets a default slug' do
        expect(search.slug).to eq 'xyz'
      end
    end
  end

  describe '#search_params' do
    it 'maps the search to the appropriate facet values' do
      expect(subject.search_params.to_hash).to include 'fq' => array_including('{!term f=genre_ssim}map')
    end

    context 'with filter_resources_by_exhibit configured' do
      before do
        allow(Spotlight::Engine.config).to receive(:filter_resources_by_exhibit).and_return(true)
      end

      it 'includes the exhibit context' do
        expect(subject.search_params.to_hash).to include 'fq' => array_including("{!term f=spotlight_exhibit_slug_#{exhibit.slug}_bsi}true")
      end
    end
  end

  describe '#repository' do
    let(:search) { FactoryBot.create(:search) }

    before do
      allow(search).to receive(:blacklight_config).and_return blacklight_config
    end

    it 'returns an exhibit specific config' do
      expect(search.send(:repository).blacklight_config).to eql blacklight_config
    end
  end

  describe '#merge_params_for_search' do
    it 'merges user-supplied parameters into the search query' do
      user_params = { view: 'x' }
      search_params = subject.merge_params_for_search(user_params, blacklight_config)
      expect(search_params).to include query_params
      expect(search_params).to include user_params
    end

    it 'preserves user pagination' do
      user_params = { page: 5, per_page: 7 }
      search_params = subject.merge_params_for_search(user_params, blacklight_config)
      expect(search_params).to include query_params
      expect(search_params).to include user_params
    end
  end

  describe '#groups' do
    let(:search) { FactoryBot.create(:search_with_groups, groups_count: 3) }

    it do
      expect(search.groups.count).to eq 3
    end

    it do
      search.groups.all do |group|
        expect(group).to be_an Spotlight::Group
      end
    end
  end
end
