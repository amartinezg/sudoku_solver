# frozen_string_literal: true

# = sudoku/node.rb
class Sudoku
  # === Sudoku::Node
  # Class that represent a single cell of the Sudoku game
  class Node
    attr_accessor :id, :candidates, :coordinates
    attr_reader :value

    def initialize(id, value = 0)
      @id = id
      @value = value
      @candidates = []
      @coordinates = []
    end

    # It replaces the value of the cell
    # @raise [ArgumentError] if value is not in range 0-9
    def fill_with_digit(value)
      raise ArgumentError, "Values from 0 to 9 accepted" unless value.to_s.match?(/^[0-9]$/)

      @value = value
    end

    # @return true if cell has a value different than 0
    def filled?
      !@value.zero?
    end

    # @return true if cell has a value of 0
    def unfilled?
      @value.zero?
    end

    # @return [Integer] size of candidates array
    def candidates_size
      @candidates.size
    end

    # @return true if cell has only one candidate
    def only_one_candidate?
      candidates_size == 1
    end

    # @return [Enumerator] array of candidates grouped in pairs with all possible combinations
    def candidates_tuplets
      @candidates.combination(2)
    end

    # @return [Enumerator] array of candidates grouped in triplets with all possible combinations
    def candidates_triplets
      @candidates.combination(3)
    end
  end
end
