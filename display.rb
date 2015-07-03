require 'IO/console'

MOVEMENTS = { 'a' => [0,-1],
              's' => [1,0],
              'd' => [0,1],
              'w' => [-1,0],
              '\r' => [0,0]
              }

class Display

	attr_reader :cursor_position, :clicked

	def initialize
		@cursor_position = [0,0]
		@clicked = false
	end

	def move_cursor(input)
		row, col = @cursor_position
		d_row, d_col = MOVEMENTS[input]
		[row+d_row, col+d_col]
	end

	def click
		@clicked = true
	end

	def clicked?
		@clicked
	end

	def unclick
		@clicked = false
	end

	def get_input
		begin
			input = $stdin.getch
			case input
			when 'a', 's', 'd', 'w'
				@cursor_position = move_cursor(input)
				return false
			when "\r"
				click
				return true
			when "z"
				return "z"
			when 'q'
				raise "QUIT"
			end
		end
	end


end

class CursorError < StandardError
end

