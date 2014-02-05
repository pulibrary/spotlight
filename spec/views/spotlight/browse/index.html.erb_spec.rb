require 'spec_helper'

describe "spotlight/browse/index" do
  let(:search) { FactoryGirl.create(:search) }
  let(:another_search) { FactoryGirl.create(:search) }

  it "should have a title" do
    render
    expect(response).to have_selector 'h1', text: "Browse Exhibit"
  end

  it "should render the collection of searches" do
    assign :searches, [search, another_search]
    stub_template "spotlight/browse/_search.html.erb" => "<%= search.id %> <br/>"
    render
    expect(response).to have_content "#{search.id} #{another_search.id}"
  end
end