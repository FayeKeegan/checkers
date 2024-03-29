require_relative 'piece.rb'
require_relative 'empty_square'
require_relative 'display'
require 'colorize'

class Board
	attr_reader :grid, :display

	def initialize(display=nil)
		@grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
		@display = display
		puts "display id " + display.object_id.to_s
	end

	def [](row, col)
		@grid[row][col]
	end

	def []=(row, col, mark)
		@grid[row][col] = mark
	end

	def setup_board
		(0..2).each do |i|
			(0..7).each do |j|
				if (i + j).odd?
					self[i,j] = Piece.new(:black, [i,j], self)
					self[i+5,j-1] = Piece.new(:white, [i+5,j-1], self)
				end
			end
		end
		nil
	end

	def dup
		duped_board = Board.new
		grid.each_with_index do |row, i|
			row.each_with_index do |square, j|
				if square.empty?
					duped_board[i,j] = EmptySquare.new
				else
					duped_board[i,j] = Piece.new(square.color, [i,j], duped_board, square.king?)
				end
			end
		end
		duped_board
	end

	def valid_move_seq?(start_pos, move_array)
		duped_board = self.dup
		begin 
			duped_board[*start_pos].perform_move!(move_array)
		rescue InvalidMoveError
		 	false
		else
			true
		end
	end

	def render
		puts ("    0  1  2  3  4  5  6  7 ")
		grid.each_with_index do |row, i|
			print_row = [" #{i} "]
			row.each_with_index do |square, j|
				if display.cursor_position == [i,j]
					print_row << square.to_s.colorize(background: :blue)
				elsif (i + j).even?
					print_row << square.to_s.colorize(background: :white)
				else
					print_row << square.to_s.colorize(background: :red)
				end
			end
			puts print_row.join("")
		end
		nil
	end

	def on_board?(pos)
		pos.all? {|i| i.between?(0, 7)}
	end

	def perform_move!(start_pos, move_array)
		self[*start_pos].perform_move!(move_array)
	end

	def all_pieces
		grid.flatten.select {|square| square.checker?}
	end
end


