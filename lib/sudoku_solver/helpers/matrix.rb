require "Matrix"

class Sudoku
  module Helpers
    module Matrix
      GLOBAL_MATRIX = ::Matrix[*(0..80).to_a.each_slice(9).to_a].freeze
      M1 = ::Matrix[[0, 1, 2], [9, 10, 11], [18, 19, 20]].freeze
      M2 = ::Matrix[[3, 4, 5], [12, 13, 14], [21, 22, 23]].freeze
      M3 = ::Matrix[[6, 7, 8], [15, 16, 17], [24, 25, 26]].freeze
      M4 = ::Matrix[[27, 28, 29], [36, 37, 38], [45, 46, 47]].freeze
      M5 = ::Matrix[[30, 31, 32], [39, 40, 41], [48, 49, 50]].freeze
      M6 = ::Matrix[[33, 34, 35], [42, 43, 44], [51, 52, 53]].freeze
      M7 = ::Matrix[[54, 55, 56], [63, 64, 65], [72, 73, 74]].freeze
      M8 = ::Matrix[[57, 58, 59], [66, 67, 68], [75, 76, 77]].freeze
      M9 = ::Matrix[[60, 61, 62], [69, 70, 71], [78, 79, 80]].freeze
      MINI_MATRICES = [M1, M2, M3, M4, M5, M6, M7, M8, M9].freeze

      def coordinates(value)
        return nil if value < 0 || value > 80

        GLOBAL_MATRIX.index(value).map { |v| v + 1 }
      end

      def find_neighbors(value)
        [find_row_neighbors(value), find_column_neighbors(value), find_box_neighbors(value)]
      end

      def find_row_neighbors(value)
        i, _j = GLOBAL_MATRIX.index(value)
        GLOBAL_MATRIX.row(i).to_a - [value]
      end

      def find_column_neighbors(value)
        _i, j = GLOBAL_MATRIX.index(value)
        GLOBAL_MATRIX.column(j).to_a - [value]
      end

      def find_box_neighbors(value)
        index = MINI_MATRICES.index { |matrix| !!matrix.index(value) }
        MINI_MATRICES[index].to_a.flatten - [value]
      end
    end
  end
end
