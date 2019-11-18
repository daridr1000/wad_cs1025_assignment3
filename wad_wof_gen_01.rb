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
			created = created_by()
			student = student_id()
			[created,student]
		end

		def created_by
			# Returns the names of the creator.
			"Darius Dragnea"
		end
		
		def student_id
			# Returns the UoA student ids of the creators.
			51984000
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
		
		def letter?(char)
			#Verifies if a char is a letter
			if (char=~/[[:alpha:]]/)==nil
				return false
			end
			return true
		end
		# Any code/methods aimed at passing the RSpect tests should be added above.

	
	end
end
