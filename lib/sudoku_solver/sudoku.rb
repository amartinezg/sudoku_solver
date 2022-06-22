require "rgl/adjacency"
require "rgl/traversal"
require "rgl/dot"

class Sudoku
  include Helpers::Utils
  include Strategies

  attr_accessor :graph, :nodes_changed_ids

  def initialize(values)
    load_matrix
    @graph = RGL::AdjacencyGraph.new
    add_edges(values)
    find_all_candidates
  end

  def process
    @nodes_changed_ids = []
    loop do
      print_sudoku
      Strategies::HiddenSingles.new(self).process
      process_nodes_changed

      puts "# Nodes unfilled: #{nodes_unfilled.size}"
      break unless done?

      puts "---------------------------------------------"
    end
  end

  def add_edges(values)
    nodes = values.each_with_index.map do |v, i|
      node = Node.new(i, v)
      node.coordinates = coordinates(i)
      node
    end

    (0..80).each do |i|
      neighbors = find_neighbors(i).flatten
      node = nodes[i]
      neighbors.each { |n| @graph.add_edge node, nodes[n] }
    end
  end

  def find_candidates(node)
    return [] if node.filled?

    (1..9).to_a - @graph.adjacent_vertices(node).select(&:filled?).map(&:value)
  end

  def find_all_candidates
    @graph.vertices.each do |node|
      candidates = find_candidates(node)
      node.candidates = candidates if candidates.any?
    end
  end

  def process_nodes_changed
    neighbors = @nodes_changed_ids.map { |id| find_neighbors(id).flatten }
    neighbors.flatten.uniq.each do |id|
      node = @graph.vertices[id]
      candidates = find_candidates(node)
      node.candidates = candidates if candidates.any?
    end
  end
end
