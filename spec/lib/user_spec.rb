require 'spec_helper'
require 'csv'


describe Leverans::Users do
  let(:data) { CSV.read(File.expand_path(File.dirname(__FILE__) + "/../fixtures/users.csv")) }
  subject {
    described_class.new(data)
  }

  it 'should have headers' do
  end

  describe '#weeks' do
    it 'show the weeks' do
      expect(subject.weeks).to eq(%w(20 21 22 23 24 25 26 27))
    end
  end

  describe '#week' do
    it 'returns users from a week' do
      expect(subject.week(23).map(&:name)).not_to include('Simon Gate')
    end

    it 'is empty if wrong week is supplied' do
      expect(subject.week(88)).to be_empty
    end
  end

  describe '#by_pickup' do
    it 'returns by pickup' do
      expect(subject.by_pickup.keys).to include('Lädja', 'Tolg')
    end
  end

  it 'returns all picksups' do
    expect(subject.pickups).to eq ['Lädja', 'Tolg' ]
  end

  it 'returns all shares' do
    expect(subject.shares).to eq ['Singel',  'Par', 'Familj']
  end

  describe '#pickup' do
    it 'returns all users in Lädja' do
      expect(subject.pickup('Lädja').map(&:name)).to include('Simon Gate', 'Sofia Asplund')
    end

    it 'returns all users in Tolg' do
      expect(subject.pickup('Tolg').map(&:name)).to include('Maja Söderberg', 'Joe Egan', 'Liisa Kivikas')
    end
  end

  it 'returns all singel shares' do
    expect(subject.share('Singel').map(&:name)).to include('Simon Gate', 'Sofia Asplund', 'Joe Egan')
  end

end

describe Leverans::User do
  let(:worksheet) { OpenStruct.new(save: true) }
  subject {
    described_class.new([
      'Simon Gate',
      'simon@smgt.me',
      'Singel',
      'Lädja',
      'Leverans', 'Leverans', 'Ingen leverans', 'Ingen leverans', 'Leverans'
    ], 1, worksheet)
  }

  it 'returns a name' do
    expect(subject.name).to eq 'Simon Gate'
  end

  it 'returns a email' do
    expect(subject.email).to eq 'simon@smgt.me'
  end

  it 'returns delivery share' do
    expect(subject.share).to eq 'Singel'
  end

  it 'returns pickup location' do
    expect(subject.pickup).to eq 'Lädja'
  end

  it 'returns a schedule' do
    expect(subject.schedule).to eq [true, true, false, false, true]
  end

  it 'has 5 scheduled weeks' do
    expect(subject.schedule.size).to eq 5
  end
end
