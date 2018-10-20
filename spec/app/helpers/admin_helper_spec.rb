require 'spec_helper'

RSpec.describe "Leverans::App::AdminHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend Leverans::App::AdminHelper }
  subject { helpers }

  it 'formats number without country code' do
    expect(subject.format_phone('0708547400')).to eq('+46708547400')
  end

  it 'formats number with alot of spaces' do
    expect(subject.format_phone('0708 54 74 00')).to eq('+46708547400')
  end

  it 'formats number with dash' do
    expect(subject.format_phone('0708-54 74 00')).to eq('+46708547400')
  end

  it 'formats number with plus in countru' do
    expect(subject.format_phone('+46708-54 74 00')).to eq('+46708547400')
  end

  it 'formats number with double zero in country' do
    expect(subject.format_phone('0046708-54 74 00')).to eq('+46708547400')
  end
end
