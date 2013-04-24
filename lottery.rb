class Lottery
  def initialize(size)
    raise ArgumentError, 'size must be larger than or equal to 0' unless size >= 0
    @size = size
    @member_table = {}
  end

  def add(member, weight)
    raise ArgumentError, 'member must be unique' unless @member_table[member].nil?
    raise ArgumentError, 'weight must be larger than 0' unless weight > 0
    @member_table[member] = weight
  end

  def winners
    array = lottery_array
    Array.new(@size){ array.delete(array.sample) }.compact
  end

  private

  def lottery_array
    @member_table.map{|member, weight| Array.new(weight, member) }.flatten
  end
end

require 'rspec'

describe Lottery do
  DELTA = 0.1
  let(:lottery) { Lottery.new(size) }
  context 'when 1 for 1' do
    let(:size) { 1 }
    before do
      lottery.add("John", 10)
    end
    subject { lottery.winners }
    specify { expect(subject.length).to eq 1 }
    specify { expect(subject).to include "John" }
  end

  context 'when 1 for 2' do
    let(:size) { 1 }
    context 'when same weight' do
      before do
        lottery.add("John", 10)
        lottery.add("Tom", 10)
        @winner_history = []
        100.times{ @winner_history << lottery.winners.first }
      end

      specify 'John wins in 1/2' do
        expect(@winner_history.count("John").to_f / @winner_history.length).to be_within(DELTA).of(0.5)
      end

      specify 'Tom wins in 1/2' do
        expect(@winner_history.count("Tom").to_f / @winner_history.length).to be_within(DELTA).of(0.5)
      end
    end

    context 'when different weight' do
      before do
        lottery.add("John", 10)
        lottery.add("Tom", 20)
        @winner_history = []
        100.times{ @winner_history << lottery.winners.first }
      end

      specify 'John wins in 1/3' do
        expect(@winner_history.count("John").to_f / @winner_history.length).to be_within(DELTA).of(1.to_f / 3)
      end

      specify 'Tom wins in 2/3' do
        expect(@winner_history.count("Tom").to_f / @winner_history.length).to be_within(DELTA).of(2.to_f / 3)
      end
    end
  end

  context 'when 1 for 3' do
    let(:size) { 1 }
    before do
      lottery.add("John", 10)
      lottery.add("Tom", 20)
      lottery.add("Bill", 30)
      @winner_history = []
      100.times{ @winner_history << lottery.winners.first }
    end

    specify 'John wins in 1/6' do
      expect(@winner_history.count("John").to_f / @winner_history.length).to be_within(DELTA).of(1.to_f / 6)
    end

    specify 'Tom wins in 2/6' do
      expect(@winner_history.count("Tom").to_f / @winner_history.length).to be_within(DELTA).of(2.to_f / 6)
    end

    specify 'Bill wins in 3/6' do
      expect(@winner_history.count("Bill").to_f / @winner_history.length).to be_within(DELTA).of(3.to_f / 6)
    end
  end

  context 'when 2 for 3' do
    let(:size) { 2 }
    before do
      lottery.add("John", 10)
      lottery.add("Tom", 20)
      lottery.add("Bill", 30)
      @winner_history = []
      100.times{ @winner_history.concat lottery.winners }
    end

    specify { expect(lottery.winners.length).to eq 2 }

    it 'returns unique winners every time' do
      10.times do
        winners = lottery.winners
        expect(winners.length).to eq winners.uniq.length
      end
    end

    specify 'John wins in 1/6' do
      expect(@winner_history.count("John").to_f / @winner_history.length).to be_within(DELTA).of(1.to_f / 6)
    end

    specify 'Tom wins in 2/6' do
      expect(@winner_history.count("Tom").to_f / @winner_history.length).to be_within(DELTA).of(2.to_f / 6)
    end

    specify 'Bill wins in 3/6' do
      expect(@winner_history.count("Bill").to_f / @winner_history.length).to be_within(DELTA).of(3.to_f / 6)
    end
  end

  context 'when 3 for 2' do
    let(:size) { 3 }
    before do
      lottery.add("John", 1)
      lottery.add("Tom", 10)
    end

    specify { expect(lottery.winners.length).to eq 2 }

    it 'returns unique winners every time' do
      10.times do
        winners = lottery.winners
        expect(winners.length).to eq winners.uniq.length
      end
    end

    it 'returns John every time' do
      10.times do
        expect(lottery.winners).to include 'John'
      end
    end

    it 'returns Tom every time' do
      10.times do
        expect(lottery.winners).to include 'Tom'
      end
    end
  end

  context 'when 3 for 5' do
    let(:size) { 3 }
    before do
      lottery.add("John", 1)
      lottery.add("Tom", 2)
      lottery.add("Bill", 5)
      lottery.add("Woz", 2)
      lottery.add("Ken", 10)
      @winner_history = []
      100.times{ @winner_history.concat lottery.winners }
    end

    specify { expect(lottery.winners.length).to eq 3 }

    specify 'John wins in 1/20' do
      expect(@winner_history.count("John").to_f / @winner_history.length).to be_within(DELTA).of(1.to_f / 20)
    end

    specify 'Tom wins in 2/20' do
      expect(@winner_history.count("Tom").to_f / @winner_history.length).to be_within(DELTA).of(2.to_f / 20)
    end

    specify 'Bill wins in 5/20' do
      expect(@winner_history.count("Bill").to_f / @winner_history.length).to be_within(DELTA).of(5.to_f / 20)
    end

    specify 'Woz wins in 2/20' do
      expect(@winner_history.count("Woz").to_f / @winner_history.length).to be_within(DELTA).of(2.to_f / 20)
    end

    specify 'Ken wins in 1/3(MAX)' do
      expect(@winner_history.count("Ken").to_f / @winner_history.length).to be_within(DELTA).of(1.to_f / 3)
    end
  end

  context 'when 0 for 1' do
    let(:size) { 0 }
    before do
      lottery.add("John", 1)
    end

    specify { expect(lottery.winners.length).to eq 0 }
  end

  context 'when 1 for 0' do
    let(:size) { 1 }
    specify { expect(lottery.winners.length).to eq 0 }
  end

  context 'when 0 for 0' do
    let(:size) { 0 }
    specify { expect(lottery.winners.length).to eq 0 }
  end

  describe "[EXCEPTIONAL]" do
    context 'when size is less than 0' do
      let(:size) { -1 }
      specify do
        expect{lottery}.to raise_error(ArgumentError)
      end
    end

    context 'when weight is less than 1' do
      let(:size) { 1 }
      specify do
        expect{lottery.add("John", 0)}.to raise_error(ArgumentError)
      end
    end

    context 'when same member added' do
      let(:size) { 2 }
      before do
        lottery.add("Tom", 20)
      end
      specify do
        expect{lottery.add("Tom", 20)}.to raise_error(ArgumentError)
      end
    end
  end
end
