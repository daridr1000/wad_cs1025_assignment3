# Ruby code file - All your code should be located between the comments provided.

# Main class module
module WOF_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 5

	class Game
		attr_reader :template, :wordtable, :input, :output, :turn, :turnsleft, :winner, :secretword, :played, :score, :resulta, :resultb, :guess
		attr_writer :template, :wordtable, :input, :output, :turn, :turnsleft, :winner, :secretword, :played, :score, :resulta, :resultb, :guess
		
		def initialize(input, output)
			@input = input
			@output = output
			@played = 0
			@score = 0
		end
		
		def getguess
			guess = @input.gets.chomp.upcase
		end
		
		def storeguess(guess)
			if guess != ""
				@resulta = @resulta.to_a.push "#{guess}"
			end
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
		def start
			# Displays a welcome message including information about the creators.
			@output.puts('Welcome to Hangman!')
			created = created_by()
			student = student_id()
			@output.puts("Created by: #{created} (#{student})")
			@output.puts('Starting game...')
			@output.puts('Enter 1 to run the game in the command-line window or 2 to run it in a web browser')
		end

		def created_by
			# Returns the names of the creator.
			"Darius Dragnea"
		end
		
		def student_id
			# Returns the UoA student ids of the creators.
			51984000
		end
		def displaymenu
			# Returns a string of different options for running the program.
			@output.puts('Menu: (1) Play | (2) New | (3) Analysis | (9) Exit')
		end
		def menuprompt
			# Returns a string prompting the user to select an option from the menu.
			"Select option from menu."
		end
		def resetgame
			# Resets all variables to their initial state.
			@wordtable = []
			@secretword = ""
			@turn = 0
			@resulta = []
			@resultb = []
			@winner = 0
			@guess = ""
			@template = "[]"
		end
		def readwordfile(filepath)
			# Reads words from the file at the specified filepath.
			words=0
			@wordtable=[]
			# Open file.
			File.open(filepath).each do |line|
				# Read each line and add words to the wordtable after removing whitespace.
				@wordtable[words]=line.strip
				words+=1
			end
			words
		end

		def gensecretword
			# Returns a random word from the wordtable.
			@wordtable[rand(@wordtable.length)].upcase
		end
		def getsecretword
			# Accessor for the secret word.
			@secretword
		end
		def setsecretword(secretword)
			# Sets the secretword to the provided word.
			@secretword=secretword
		end

		def createtemplate
			# Creates the template for the secret word.
			@template = "[#{'_' * @secretword.length}]"
			
		end

		def getsecrettemplate
			# Returns the secret word and template as an array.
			[@secretword, @template]
		end
		def incrementturn
			# Increments the turn counter.
			@turn += 1
		end

		def getturnsleft
			# Returns the number of turns left for the player.
			@turnsleft = GOES - @turn
		end
		def displaytemplate
			# Displays the template.
			getsecrettemplate
			@output.puts @template
		end
		def charinword(char)
			# Returns the number of occurences of the characters in the secret word.
			@secretword.count(char)
		end

		def showcharinword(char)
			# Updates the template to display all characters already entered by the user.
			# New template with the starting character already in it.	
			newtemplate = ['[']
			# Iterate through the secret word.
			for i in (0...@secretword.length)
				# Check if the entered char is at the position.
				if char == @secretword[i]
					# If it is, append the character to the word.
					newtemplate << char
				else
					# Otherwise, append the old character from the template.
					newtemplate << @template[i+1]
				end
			end
			# Add ending character.
			newtemplate << ']'
			# Joins the new template into a string.
			@template = newtemplate.join
			# Display the template.
			@output.puts @template
		end

		def checkifwon
			# Checks if the player has won in the last move.
			if @template.count('_') == 0
				1
			else
				0
			end
		end

		def revealword
			# Return the secret word.
			@secretword
		end
		def incrementplayed
			# Increments the played variable.
			@played += 1
		end
		def incrementscore
			# Increments the score by one.
			@score += 1
		end
		# Any code/methods aimed at passing the RSpect tests should be added above.

	
	end
end
