# frozen_string_literal: true

require "./examples/easy"
RSpec.describe Sudoku::Strategies::NakedPairs do
  include Examples::Easy

  before(:all) do
    @game = Sudoku.new(pick(0))
  end

  subject { Sudoku::Strategies::NakedPairs.new(@game) }

  describe "#nodes_with_two_candidates" do
    it "should be an array" do
      expect(subject.nodes_with_two_candidates).to be_a Array
    end

    it "has a size of 15 nodes" do
      expect(subject.nodes_with_two_candidates.size).to eq(15)
    end

    it "has a size of 2 candidates on each cell" do
      subject.nodes_with_two_candidates do |node|
        expect(node.candidates.size).to eq(2)
      end
    end

    it "has the right ids of nodes which have single candidates" do
      res = [5, 9, 36, 54, 11, 19, 64, 38, 56, 48, 50, 77, 33, 26, 35]
      expect(subject.nodes_with_two_candidates.map(&:id)).to eq(res)
    end

    it "has the right candidate for each of the 7 nodes" do
      candidates = subject.nodes_with_two_candidates.map(&:candidates)
      expect(candidates[0]).to eq([8, 9])
      expect(candidates[1]).to eq([7, 9])
      expect(candidates[2]).to eq([1, 9])
      expect(candidates[3]).to eq([5, 7])
      expect(candidates[4]).to eq([3, 9])
      expect(candidates[5]).to eq([3, 8])
      expect(candidates[6]).to eq([3, 7])
      expect(candidates[7]).to eq([1, 9])
      expect(candidates[8]).to eq([3, 4])
      expect(candidates[9]).to eq([1, 9])
      expect(candidates[10]).to eq([1, 9])
      expect(candidates[11]).to eq([3, 8])
      expect(candidates[12]).to eq([1, 9])
      expect(candidates[13]).to eq([8, 9])
      expect(candidates[14]).to eq([1, 9])
    end
  end

  describe "#cells_with_same_candidates" do
    before do
      @node = @game.find_node_with_id(36)
      @row_neighbors = @game.find_nodes_with_ids(@node.neighbors[0])
      @column_neighbors = @game.find_nodes_with_ids(@node.neighbors[1])
      @box_neighbors = @game.find_nodes_with_ids(@node.neighbors[2])
    end

    it "has the right id" do
      expect(@node.id).to eq(36)
    end

    it "has the right row neighbors ids" do
      expect(@row_neighbors.map(&:id)).to eq([37, 38, 39, 40, 41, 42, 43, 44])
    end

    it "has the right column neighbors ids" do
      expect(@column_neighbors.map(&:id)).to eq([0, 9, 18, 27, 45, 54, 63, 72])
    end

    it "has the right box neighbors ids" do
      expect(@box_neighbors.map(&:id)).to eq([27, 28, 29, 37, 38, 45, 46, 47])
    end

    context "when analyzing same row" do
      let(:same_candidates) { subject.cells_with_same_candidates(@row_neighbors, @node.candidates) }

      it "nodes returned should return an Array" do
        expect(same_candidates).to be_a Array
      end

      it "nodes returned should have a size of 1" do
        expect(same_candidates.size).to eq(1)
      end

      it "node returned should have same candidates than node evaluated" do
        expect(same_candidates.first.candidates).to eq(@node.candidates)
      end

      it "node returned should have the right id and coordinates" do
        expect(same_candidates.first.id).to eq(38)
        expect(same_candidates.first.coordinates).to eq([5, 3])
      end

      it "should be empty" do
        expect(same_candidates.first.unfilled?).to be_truthy
      end
    end

    context "when analyzing same column" do
      let(:same_candidates) { subject.cells_with_same_candidates(@column_neighbors, @node.candidates) }

      it "nodes returned should return an Array" do
        expect(same_candidates).to be_a Array
      end

      it "nodes returned should have a size of 0" do
        expect(same_candidates.size).to eq(0)
      end
    end
  end

  describe "#collect_nodes_to_clean" do
    let(:node) { @game.find_node_with_id(36) }
    let(:nodes_with_same_candidates) { @game.find_nodes_with_ids([38]) }
    before { subject.collect_nodes_to_clean(node, nodes_with_same_candidates, :row_neighbors) }

    context "nodes to clean" do
      before { @nodes_to_clean = subject.instance_variable_get(:@nodes_to_clean) }

      it "should not be empty" do
        expect(@nodes_to_clean.empty?).to be_falsey
      end

      it "should be a hash" do
        expect(@nodes_to_clean).to be_a Hash
      end

      it "should has 1 elemet" do
        expect(@nodes_to_clean.size).to eq(1)
      end

      it "candidates to clean are 1 and 9" do
        expect(@nodes_to_clean.keys.first).to eq([1, 9])
      end

      it "candidate nodes should include 1 or 9" do
        @nodes_to_clean.values.first.each do |node|
          expect(node.unfilled?).to be_truthy
          expect((node.candidates & [1, 9]).any?).to be_truthy
        end
      end
    end
  end

  describe "#delete_useless_candidates_from_nodes" do
    let(:nodes_to_clean) { { [1, 9] => @game.find_nodes_with_ids([42, 43, 51, 52]) } }
    before { subject.instance_variable_set(:@nodes_to_clean, nodes_to_clean) }
    before { subject.delete_useless_candidates_from_nodes }

    context "node with id 42" do
      it "should delete 1 and 9 from node" do
        expect((@game.find_node_with_id(42).candidates & [1, 9]).any?).to be_falsey
      end

      it "should be unfilled" do
        expect(@game.find_node_with_id(42).unfilled?).to be_truthy
      end
    end

    context "node with id 43" do
      it "should delete 1 and 9 from node" do
        expect((@game.find_node_with_id(43).candidates & [1, 9]).any?).to be_falsey
      end

      it "should be unfilled" do
        expect(@game.find_node_with_id(43).unfilled?).to be_truthy
      end
    end

    context "node with id 51" do
      it "should delete 1 and 9 from node" do
        expect((@game.find_node_with_id(51).candidates & [1, 9]).any?).to be_falsey
      end

      it "should be unfilled" do
        expect(@game.find_node_with_id(51).unfilled?).to be_truthy
      end
    end

    context "node with id 52" do
      it "should delete 1 and 9 from node" do
        expect((@game.find_node_with_id(52).candidates & [1, 9]).any?).to be_falsey
      end

      it "should be unfilled" do
        expect(@game.find_node_with_id(52).unfilled?).to be_truthy
      end
    end

    context "Nodes visited" do
      it "should not be empty" do
        expect(@game.nodes_changed_ids.empty?).to be_falsey
      end

      it "should include 42, 43, 51 and 52" do
        expect((@game.nodes_changed_ids & [42, 43, 51, 52]).size).to eq(4)
      end
    end
  end
end
