# frozen_string_literal: true

require_relative "sudoku_solver/version"
require_relative "sudoku_solver/helpers/matrix"
require_relative "sudoku_solver/helpers/utils"
require_relative "sudoku_solver/sudoku/strategies/hidden_singles"
require_relative "sudoku_solver/sudoku/strategies/naked_pairs"
require_relative "sudoku_solver/sudoku"
require_relative "sudoku_solver/sudoku/node"

module SudokuSolver
  class Error < StandardError; end
  # Your code goes here...
end
