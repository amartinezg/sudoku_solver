require 'Matrix'

class Sudoku
  module Helpers
    module Utils
      def load_matrix
        @mm = Matrix[*(0..80).to_a.each_slice(9).to_a]
        @mini_matrices = []
        fill_sub_matrices
      end

      def print_by_row
        (0..8).each { |i| puts @mm.row(i).to_a.join(" - ") }
      end

      def print_by_column
        (0..8).each { |i| puts @mm.column(i).to_a.join(" - ") }
      end

      def print_by_matrix
        @mini_matrices.each_with_index do |m, i|
          puts "------------ Printing Matrix # #{i + 1} -------- "
          puts m
        end
      end

      def coordinates(value)
        @mm.index(value).map { |n| n + 1 }
      end

      def find_neighbors(value)
        i, j = @mm.index(value)
        row_neighbors = @mm.row(i).to_a - [value]
        column_neighbors = @mm.column(j).to_a - [value]

        index = @mini_matrices.index { |matrix| !!matrix.index(value) }
        matrix_neighbors = @mini_matrices[index].to_a.flatten - [value]

        [row_neighbors, column_neighbors, matrix_neighbors]
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

      def extract_mini_matrices(i, j)
        c = [[], [], []]
        (i..j).each do |x|
          row = @mm.row(x).to_a.each_slice(3).to_a
          c[0] << row[0]
          c[1] << row[1]
          c[2] << row[2]
        end
        c
      end

      def fill_sub_matrices
        extract_mini_matrices(0, 2).each { |c| @mini_matrices << Matrix[*c] }
        extract_mini_matrices(3, 5).each { |c| @mini_matrices << Matrix[*c] }
        extract_mini_matrices(6, 8).each { |c| @mini_matrices << Matrix[*c] }
        true
      end

      def all_rows_valid?
        rows_validated = (0..8).map do |row_index|
          row = @mm.row(row_index).to_a
          row_nodes = @graph.vertices.find_all { |n| row.include?(n.id) }
          row_nodes_filtered = row_nodes.map(&:value).select(&:positive?)

          row_nodes_filtered.group_by { |v| v }.all? { |_k, v| v.size == 1 }
        end

        rows_validated.all?(true)
      end

      def all_columns_valid?
        columns_validated = (0..8).map do |column_index|
          column = @mm.column(column_index).to_a
          column_nodes = @graph.vertices.find_all { |n| column.include?(n.id) }
          column_nodes_filtered = column_nodes.map(&:value).select(&:positive?)

          column_nodes_filtered.group_by { |v| v }.all? { |_k, v| v.size == 1 }
        end

        columns_validated.all?(true)
      end

      def all_matrix_valid?
        matrices_validated = @mini_matrices.each_with_index.map do |matrix, _i|
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
