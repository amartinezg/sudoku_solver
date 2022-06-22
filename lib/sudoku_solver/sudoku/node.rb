class Sudoku
  class Node
    attr_accessor :id, :value, :candidates, :coordinates

    def initialize(id, value = 0)
      @id = id
      @value = value
      @candidates = []
      @coordinates = []
    end

    def filled?
      !@value.zero?
    end

    def unfilled?
      @value.zero?
    end

    def candidates_size
      @candidates.size
    end

    def only_one_candidate?
      candidates_size == 1
    end

    def candidates_tuplets
      @candidates.combination(2)
    end

    def candidates_triplets
      @candidates.combination(3)
    end
  end
end
