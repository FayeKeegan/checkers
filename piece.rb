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

	def is_king?
		@is_king
	end

	def make_king
		@is_king = true
	end

	def perform_slide(end_pos)
		row, col = end_pos
		if valid_slides.include?(end_pos)
			make_king if (row == 0 && red? || row == 7 && black?)
			true
		else
			false
		end
	end

	def red?
		color == :red
	end

	def black
		color == :black
	end

	def other_color?(other_piece)
		color != other_piece.color
	end

	def perform_jump(end_pos)
	end

	def valid_slides
		row, col = pos
		end_positions = []
		slide_diffs.each do |d_row, d_col|
			new_row, new_col = row+d_row, col+d_col
			if on_board?([new_row, new_row]) && board[new_row, new_col].empty?
				end_positions << [new_row, new_col]
		end
		end_positions
	end

	def on_board(pos)
		row, col = pos
		row.between?(0, 8) && col.between?(0,8)
	end


	def slide_diffs
		return SLIDE_DIFFS + JUMP_DIFFS if is_king?
		color == :red? ? SLIDE_DIFFS.take(2) : SLIDE_DIFFS.drop(2) 
	end

	def jump_diffs
		return JUMP_DIFFS if is_king?
		color == :red? ? JUMP_DIFFS.take(2) : JUMP_DIFFS.drop(2)
	end



	
end
