# frozen_string_literal: true

require "./examples/easy"
RSpec.describe Sudoku::Strategies::HiddenSingles do
  include Examples::Easy

  before(:all) do
    @game = Sudoku.new(pick(1))
  end

  subject { Sudoku::Strategies::HiddenSingles.new(@game) }

  describe "#nodes_with_one_candidate" do
    it "should be an array" do
      expect(subject.nodes_with_one_candidate).to be_a Array
    end

    it "has a size of 7 nodes" do
      expect(subject.nodes_with_one_candidate.size).to eq(7)
    end

    it "has a size of 1 candidate on each cell" do
      subject.nodes_with_one_candidate do |node|
        expect(node.candidates.size).to eq(1)
      end
    end

    it "has the right ids of nodes which have single candidates" do
      expect(subject.nodes_with_one_candidate.map(&:id)).to eq([5, 47, 74, 12, 31, 68, 71])
    end

    it "has the right candidate for each of the 7 nodes" do
      nodes = subject.nodes_with_one_candidate.map(&:candidates).flatten
      expect(nodes).to eq([4, 7, 9, 7, 7, 6, 8])
    end
  end

  describe "#process" do
    before do
      subject.process
    end

    context "fill right values" do
      it "value of node with id 5 is 4" do
        expect(@game.find_cell_with_id(5).value).to eq(4)
      end

      it "value of node with id 47 is 7" do
        expect(@game.find_cell_with_id(47).value).to eq(7)
      end

      it "value of node with id 74 is 9" do
        expect(@game.find_cell_with_id(74).value).to eq(9)
      end

      it "value of node with id 12 is 7" do
        expect(@game.find_cell_with_id(12).value).to eq(7)
      end

      it "value of node with id 31 is 7" do
        expect(@game.find_cell_with_id(31).value).to eq(7)
      end

      it "value of node with id 68 is 6" do
        expect(@game.find_cell_with_id(68).value).to eq(6)
      end

      it "value of node with id 71 is 8" do
        expect(@game.find_cell_with_id(71).value).to eq(8)
      end
    end

    context "visited nodes" do
      it "hast the right ids" do
        expect(@game.nodes_changed_ids).to eq([5, 47, 74, 12, 31, 68, 71])
      end
    end
  end
end
