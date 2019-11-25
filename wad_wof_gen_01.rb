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
			@template = "#{'_' * @secretword.length}"
			#Revealing the existing spaces of the secret word
			for i in (0..@template.length)
				if @secretword[i]==" "
					@template[i]=" "
				end
			end
		end
		def getsecrettemplate
			# Returns the template as an array.
			@template
		end
		def getsecretword
			#Returns the secret word as an array
			@secretword
		end

		def getname(file,name)
			#Adds the name of the player to the text file
			file=File.open(file,"a")			
			file.puts name
			#Closing the file
			file.close
		end

		def getscore_secretword(file)
			#Adds the score of the player and the secret word to the text file
			file=File.open(file,"a")			
			file.puts @score
			file.puts @secretword
			#Closing the file
			file.close
		end
		def getleaderboardcontent(file)
			# Takes the content of the file and saves it in a tri-dimensional array
			files=File.open(file).to_a
			#Initializing a 3 dimensional array which will contain the names, the scores of the players and the word they have tried to guess 
			names=Array.new
			for i in (0..files.length).step(3)
			#Appending the names, the scores and the words to the 3 dimensional array accordingly
				names+=[[files[i],files[i+1],files[i+2]]]
			end	
			#Deleting the last remaining space
			names.delete_at(names.length-1)
			#Sorting the whole array in descending order by score 
			names=names.sort_by {|k|k[1]}.reverse
			names
		end
		def checkifletter(letter)
			#Checks whether the typed letter is in the secret word or not 
			for i in(0..@secretword.length)
				if letter==$secretword[i]
					return true
				end
			end
			return false
		end

		def showcharinword(letter)
			#Reveals the letter in the template
			for i in(0..@template.length)
				if letter==@secretword[i]
					@template[i]=letter
				end
			end
		end
		def updatescore_lives
			#Updates score and lives variables 
			@lives-=1
			@score-=10*@secretword.length
		end

		def getscorezero
			#Initializes the score with 0
			@score=0
		end
		def resetgame
			#Initializes the lives and scores variables and the array which contains all the letters of the alphabet
			@lives=5
			@score=100*@secretword.length
			@letters=*('A'..'Z')
		end
		def getscore_lives
			#Returns the score and lives variables
			return @score,@lives
		end
		def checkifwin
			#Checks if player won the game
			@template == @secretword
		end
		def checkifloss
			#Checks if player lost the game
			@lives==0
		end
		def getletters
			@letters
		end
		def eliminate_letter(letter)
			#Eliminates the typed letter from the letters array
			index=$letters.index(letter)
			@letters[index]=""	
		end

		def letterinarray(letter)
			#Checks if a letter is in the letters array
			if @letters.include? letter
				return true
			end
			return false
		end
		# Any code/methods aimed at passing the RSpect tests should be added above.
		
	end
end
