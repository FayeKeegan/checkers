class Piece

	SLIDE_DIFFS =[[-1,1],
				[-1, -1],
				[ 1, -1],
				[ 1,  1]]	

	JUMP_DIFFS =[[-2, 2],
				[-2, -2],
				[ 2, -2],
				[-2,  2]]

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
	end

	def perform_jump(end_pos)
	end


	def move_diffs
		return SLIDE_DIFFS + JUMP_DIFFS if is_king?
		color == :red? ? SLIDE_DIFFS.take(2) + JUMP_DIFFS.take(2) : SLIDE_DIFFS.drop(2) + JUMP_DIFFS.drop()
	end


	
end
