require_relative 'board'

class InvalidMoveError < StandardError
end


class Piece

	SLIDE_DIFFS =[[-1,1],
				[-1, -1],
				[ 1, -1],
				[ 1,  1]]	

	JUMP_DIFFS =[[-2, 2],
				[-2, -2],
				[ 2, -2],
				[ 2,  2]]

	attr_accessor :pos, :board
	attr_reader :color

	def perform_move!(move_array)
		if valid_slides.include?(move_array.first)
			raise InvalidMoveError if move_array.length != 1
			perform_slide(move_array.first)
		else
			move_array.each do |move|
				raise InvalidMoveError unless valid_jumps.include?(move)
				perform_jump(move)
			end
		end
	end

	def initialize(color, pos, board, is_king=false)
		@color = color
		@pos = pos
		@board = board
		@is_king = is_king
	end

	def jumped_pos(end_pos)
		end_row, end_col = end_pos
		row, col = pos
		[(end_row + row)/2, (end_col+col)/2]
	end

	def remove_jumped_piece(end_pos)
		puts jumped_pos(end_pos).to_s
		board[*jumped_pos(end_pos)] = EmptySquare.new
	end

	def perform_jump(end_pos)
		if valid_jumps.include?(end_pos)
			remove_jumped_piece(end_pos)
			place_piece(end_pos)
			maybe_promote
			true
		else
			false
		end
	end

	def place_piece(end_pos)
		board[*self.pos] = EmptySquare.new
		self.pos = end_pos
		board[*end_pos] = self
		nil
	end

	def perform_slide(end_pos)
		row, col = end_pos
		if valid_slides.include?(end_pos)
			place_piece(end_pos)
			maybe_promote
			true
		else
			false
		end
	end

	def valid_slides
		row, col = pos
		end_positions = []
		slide_diffs.each do |d_row, d_col|
			new_row, new_col = (row+d_row), (col+d_col)
			if on_board_and_empty?([new_row, new_col])
				end_positions << [new_row, new_col]
			end
		end
		puts end_positions.to_s
		end_positions
	end

	def valid_jumps
		row, col = self.pos
		end_positions = []
		jump_diffs.each do |d_row, d_col|
			new_row, new_col= (row+d_row), (col+d_col)
			jumped_row, jumped_col = row+(d_row/2), col+(d_col/2)
			if on_board_and_empty?([new_row, new_col]) && enemy?([jumped_row, jumped_col])
				end_positions << [new_row, new_col]
			end
		end
		end_positions
	end

	def to_s
		case
		when black? && king?
			" \u265A "
		when black? && !king?
			" \u25CF "
		when white? && king?
			" \u265A "
		when white? && !king?
			" \u25CB "
		end
	end


	def king?
		@is_king
	end

	def promote
		@is_king = true
	end

	def maybe_promote
		row, col = pos
		promote if (row == 0 && white? || row == 7 && black?)
	end

	def white?
		color == :white
	end

	def black?
		color == :black
	end

	def other_color
		color == :white ? :black : :white
	end

	def on_board_and_empty?(end_pos)
		on_board?(end_pos) && board[*end_pos].empty?
	end

	def on_board?(end_pos)
		row, col = end_pos
		row.between?(0, 7) && col.between?(0, 7)
	end

	def empty?
		false
	end

	def checker?
		true
	end

	def enemy?(pos)
		board[*pos].checker? && (board[*pos].color == other_color)
	end

	def slide_diffs
		return SLIDE_DIFFS if king?
		white? ? SLIDE_DIFFS.take(2) : SLIDE_DIFFS.drop(2) 
	end

	def jump_diffs
		return JUMP_DIFFS if king?
		white? ? JUMP_DIFFS.take(2) : JUMP_DIFFS.drop(2)
	end
end


