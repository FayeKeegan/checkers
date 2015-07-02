require_relative 'piece'
require_relative 'empty_square'
require 'colorize'

class Board

	attr_reader :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
	end

	def [](row, col)
		@grid[row][col]
	end

	def []=(row, col, mark)
		@grid[row][col] = mark
	end



	def setup_board
	end

	def render
		grid.each_with_index do |row, i|
			print_row = []
			row.each_with_index do |square, j|
				if (i + j).even?
					print_row << square.to_s.colorize(background: :blue)
				else
					print_row << square.to_s.colorize(background: :light_blue)
				end
			end
			puts print_row.join("")
		end
		nil
	end

	def setup_test_board

	end


end
