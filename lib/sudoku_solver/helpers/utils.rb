class Sudoku
  module Helpers
    include Matrix

    module Utils

      def print_by_row
        (0..8).each { |i| puts Sudoku::GLOBAL_MATRIX.row(i).to_a.join(" - ") }
      end

      def print_by_column
        (0..8).each { |i| puts Sudoku::GLOBAL_MATRIX.column(i).to_a.join(" - ") }
      end

      def print_by_matrix
        Sudoku::MINI_MATRICES.each_with_index do |m, i|
          puts "------------ Printing Matrix # #{i + 1} -------- "
          puts m
        end
      end

      def find_node_with_id(id)
        @graph.vertices.select { |node| node.id == id }.first
      end

      def find_nodes_with_ids(ids)
        ids.map { |id| find_node_with_id(id) }
      end

      def find_cell_with_coordinates(x, y)
        @graph.vertices.select { |node| node.coordinates == [x, y] }.first
      end

      def print_sudoku
        puts "Is sudoku valid? #{valid_sudoku?}"
        puts "-" * 26
        @graph.vertices.sort { |a, b| a.id <=> b.id }.each_slice(9).each_with_index do |row, i|
          puts row.map(&:value).insert(3, " | ").insert(7, " | ").join(" ")
          puts "-" * 26 if [2, 5, 8].include?(i)
        end
      end

      def valid_sudoku?
        all_rows_valid? && all_columns_valid? && all_matrix_valid?
      end

      def done?
        nodes_unfilled.any?
      end

      def nodes_unfilled
        @graph.vertices.select(&:unfilled?)
      end

      private

      def all_rows_valid?
        rows_validated = (0..8).map do |row_index|
          row = Sudoku::GLOBAL_MATRIX.row(row_index).to_a
          row_nodes = @graph.vertices.find_all { |n| row.include?(n.id) }
          row_nodes_filtered = row_nodes.map(&:value).select(&:positive?)

          row_nodes_filtered.group_by { |v| v }.all? { |_k, v| v.size == 1 }
        end

        rows_validated.all?(true)
      end

      def all_columns_valid?
        columns_validated = (0..8).map do |column_index|
          column = Sudoku::GLOBAL_MATRIX.column(column_index).to_a
          column_nodes = @graph.vertices.find_all { |n| column.include?(n.id) }
          column_nodes_filtered = column_nodes.map(&:value).select(&:positive?)

          column_nodes_filtered.group_by { |v| v }.all? { |_k, v| v.size == 1 }
        end

        columns_validated.all?(true)
      end

      def all_matrix_valid?
        matrices_validated = Sudoku::MINI_MATRICES.each_with_index.map do |matrix, _i|
          matrix_indexes = matrix.to_a.flatten
          matrix_nodes = @graph.vertices.find_all { |n| matrix_indexes.include?(n.id) }
          matrix_nodes_filtered = matrix_nodes.map(&:value).select(&:positive?)

          matrix_nodes_filtered.group_by { |v| v }.all? { |_k, v| v.size == 1 }
        end

        matrices_validated.all?(true)
      end
    end
  end
end
