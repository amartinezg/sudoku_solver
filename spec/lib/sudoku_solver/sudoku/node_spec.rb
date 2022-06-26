# frozen_string_literal: true

RSpec.describe Sudoku::Node do
  context "When cell is empty" do
    subject { Sudoku::Node.new(3) }

    describe "#filled" do
      it "returns false" do
        expect(subject.filled?).to be_falsey
      end
    end

    describe "#unfilled?" do
      it "return true" do
        expect(subject.unfilled?).to be_truthy
      end
    end
  end

  context "When cell is not empty" do
    subject { Sudoku::Node.new(3, 8) }
    describe "#filled" do
      it "returns true" do
        expect(subject.filled?).to be_truthy
      end
    end

    describe "#unfilled?" do
      it "return false" do
        expect(subject.unfilled?).to be_falsey
      end
    end
  end

  context "When has candidates" do
    subject { Sudoku::Node.new(3) }

    context "and it's only 1 candidate" do
      before do
        subject.candidates = [3]
      end

      describe "#candidates_size" do
        it "should be 1" do
          expect(subject.candidates_size).to eq(1)
        end
      end

      describe "#only_one_candidate?" do
        it "returns true" do
          expect(subject.only_one_candidate?).to be_truthy
        end
      end
    end

    context "and it has multiple candidates" do
      before do
        subject.candidates = [2, 4, 5, 6, 7]
      end

      describe "#candidates_size" do
        it "should be 5" do
          expect(subject.candidates_size).to eq(5)
        end
      end

      describe "#only_one_candidate?" do
        it "returns false" do
          expect(subject.only_one_candidate?).to be_falsey
        end
      end

      describe "#candidates_tuplets" do
        it "size should be 10" do
          expect(subject.candidates_tuplets.size).to eq(10)
        end

        it "has the right tuplets" do
          res = [[2, 4], [2, 5], [2, 6], [2, 7], [4, 5], [4, 6], [4, 7], [5, 6], [5, 7], [6, 7]]
          expect(subject.candidates_tuplets.to_a).to eq(res)
        end
      end

      describe "#candidates_triplets" do
        it "size should be 10" do
          expect(subject.candidates_triplets.size).to eq(10)
        end

        it "has the right tuplets" do
          res = [[2, 4, 5], [2, 4, 6], [2, 4, 7], [2, 5, 6], [2, 5, 7], [2, 6, 7], [4, 5, 6],
                 [4, 5, 7], [4, 6, 7], [5, 6, 7]]
          expect(subject.candidates_triplets.to_a).to eq(res)
        end
      end
    end
  end

  context "When assigning values" do
    subject { Sudoku::Node.new(3) }

    describe "#fill_with_digit" do
      context "and the value is wrong" do
        it "should raise an ArgumentError exception" do
          expect { subject.fill_with_digit(23) }.to raise_error(ArgumentError)
        end
      end

      context "and the value is accepted" do
        it "should has the new value updated" do
          subject.fill_with_digit(4)
          expect(subject.value).to eq(4)
        end
      end
    end
  end
end
