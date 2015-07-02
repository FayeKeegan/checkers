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
			#remove jumped piece from board
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
		row, col = pos
		end_positions = []
		slide_diffs.each do |d_row, d_col|
			new_pos = row+d_row, col+d_col
			if on_board_and_empty?(new_pos)
				end_positions << new_pos
			end
		end
		end_positions
	end

	def valid_jumps
		row, col = self.pos
		end_positions = []
		jump_diffs.each do |d_row, d_col|
			new_pos = row+d_row, col+d_col
			jump_pos = row+(d_row/2), col+(d_col/2)
			if on_board_and_empty?(new_pos) && enemy?(jump_pos)
				end_positions << new_pos
			end
		end
		end_positions
	end

	def to_s
		case
		when black? && king?
			" \u263A "
		when black? && !king?
			" \u25CF "
		when white? && king?
			" \u263B "
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


