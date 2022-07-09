# frozen_string_literal: true

# = naked_pairs.rb
class Sudoku
  module Strategies
    class NakedPairs
      # @param game [Sudoku]
      def initialize(game)
        @game = game
        @nodes_to_clean = {}
      end

      def process
        # puts "Executing #{self.class.name}"
        nodes_with_two_candidates.each do |node|
          #puts "Coordinates: #{node.coordinates} - Candidate: #{node.candidates} - id: #{node.id}"

          row_n, column_n, box_n = node.neighbors.map { |neigh| @game.find_nodes_with_ids(neigh) }

          collect_nodes_to_clean(node, cells_with_same_candidates(row_n, node.candidates), :row_neighbors)
          collect_nodes_to_clean(node, cells_with_same_candidates(column_n, node.candidates), :column_neighbors)
          collect_nodes_to_clean(node, cells_with_same_candidates(box_n, node.candidates), :box_neighbors)
        end
        delete_useless_candidates_from_nodes
      end

      def nodes_with_two_candidates
        @game.graph.vertices.select(&:only_two_candidates?)
      end

      def cells_with_same_candidates(neighbors, tuplet)
        neighbors.select do |node|
          node.only_two_candidates? && node.candidates == tuplet
        end
      end

      def collect_nodes_to_clean(node, nodes_with_same_candidates, where_to_search)
        nodes_with_same_candidates.each do |node_candidate|
          nodes_to_delete_candidates = node_candidate.public_send(where_to_search) - [node.id]
          unfilled_nodes = @game.find_nodes_with_ids(nodes_to_delete_candidates).select(&:unfilled?)
          next if unfilled_nodes.empty?

          key = node.candidates.sort
          @nodes_to_clean[key] = (@nodes_to_clean[key].to_a + unfilled_nodes).uniq
        end
      end

      def delete_useless_candidates_from_nodes
        @nodes_to_clean.each do |candidates, nodes|
          #puts "Deleting candidates: #{candidates} from nodes: #{nodes.map(&:id)}"

          nodes.each do |node|
            node.candidates = node.candidates - candidates
            @game.nodes_changed_ids << node.id
          end
        end
      end
    end
  end
end
