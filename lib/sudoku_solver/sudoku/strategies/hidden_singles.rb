class Sudoku
  module Strategies
    class HiddenSingles
      def initialize(game)
        @game = game
      end

      def process
        puts "Executing #{self.class.name}"

        nodes_with_one_candidate.each do |node|
          puts "Coordinates: #{node.coordinates} - Candidate: #{node.candidates}"
          node.value = node.candidates.first
          node.candidates = []
          @game.nodes_changed_ids << node.id
        end
      end

      def nodes_with_one_candidate
        @game.graph.vertices.select(&:only_one_candidate?)
      end
    end
  end
end
