require_relative 'board'

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

	def initialize(color, pos, board, is_king=false)
		@color = color
		@pos = pos
		@board = board
		@is_king = is_king
	end

	def perform_jump(end_pos)
		if valid_jumps.include?(end_pos)
			maybe_promote
			place_piece(end_pos)
			true
		else
			false
		end
	end

	def place_piece(end_pos)
		self.pos = end_pos
		board[*end_pos] = self
	end

	def perform_slide(end_pos)
		row, col = end_pos
		if valid_slides.include?(end_pos)
			maybe_promote
			place_piece(end_pos)
			true
		else
			false
		end
	end

	def valid_slides
		row, col = self.pos
		end_positions = []
		slide_diffs.each do |d_row, d_col|
			new_row, new_col = row+d_row, col+d_col
			if on_board_and_empty?([new_row, new_col])
				end_positions << [new_row, new_col]
			end
		end
		end_positions
	end

	def valid_jumps
		row, col = self.pos
		end_positions = []
		jump_diffs.each do |d_row, d_col|
			new_row, new_col = row+d_row, col+d_col
			jumped_row, jumped_col = row+(d_row/2), col+(d_col/2)
			if on_board_and_empty?([new_row, new_col]) && enemy?([jumped_row, jumped_col])
				end_positions << [new_row, new_col]
			end
		end
		end_positions
	end

	def to_s
		case
		when white? && king?
			" \u263A "
		when white? && !king?
			" \u25CF "
		when black? && king?
			" \u263B "
		when black? && !king?
			" \u25CB "
		end
	end


	def is_king?
		@is_king
	end

	def promote
		@is_king = true
	end

	def maybe_promote
		promote if (row == 0 && white? || row == 7 && black?)
	end

	def white?
		color == :white
	end

	def black?
		color == :black
	end

	def other_color?(other_piece)
		color != other_piece.color
	end

	def on_board_and_empty?(end_pos)
		on_board?(end_pos) && empty?(end_pos)
	end

	def on_board?(end_pos)
		row, col = end_pos
		row.between?(0, 8) && col.between?(0, 8)
	end

	def empty?(end_pos)
		board[*pos].empty?
	end

	def enemy?(pos)
		on_board?(pos) && (board[*pos].color == other_color)
	end

	def slide_diffs
		return SLIDE_DIFFS + JUMP_DIFFS if is_king?
		color == :white? ? SLIDE_DIFFS.take(2) : SLIDE_DIFFS.drop(2) 
	end

	def jump_diffs
		return JUMP_DIFFS if is_king?
		color == :white? ? JUMP_DIFFS.take(2) : JUMP_DIFFS.drop(2)
	end

	
end
