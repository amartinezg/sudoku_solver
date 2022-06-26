# frozen_string_literal: true

# = hidden_singles.rb
class Sudoku
  module Strategies
    # === HiddenSingles class
    #
    # It determines if a candidate value for a cell is the last option available on: a matrix, a row or a column
    class HiddenSingles
      # @param game [Sudoku]
      def initialize(game)
        @game = game
      end

      # It traverses all nodes with one candidate and changes the current value with the only candidate available
      # It pushes the _id_ of the node on +nodes_changed_ids+ array
      def process
        # puts "Executing #{self.class.name}"

        nodes_with_one_candidate.each do |node|
          # puts "Coordinates: #{node.coordinates} - Candidate: #{node.candidates} - id: #{node.id}"
          node.fill_with_digit(node.candidates.first)
          node.candidates = []
          @game.nodes_changed_ids << node.id
        end
      end

      # @return [Sudoku::Node] nodes which have only one candidate available
      def nodes_with_one_candidate
        @game.graph.vertices.select(&:only_one_candidate?)
      end
    end
  end
end
