require "rails_helper"

RSpec.describe MaterialAttributeSerializer do
  subject { described_class.new(material) }
  let(:material) { create(:material, cti: nil) }

  it "does not convert cti to zero" do
    expect(subject.as_json.fetch(:cti)).to be(nil)
  end
end
