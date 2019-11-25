# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_wof_gen_01"



set	:bind,'0.0.0.0'

# Main program
module WOF_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	secret = ""
	filename = "wordfile.txt"
	turn = 0
	win = 0
	game = ""
	words = 0
	@output.puts 'Enter "1" runs game in command-line window or "2" runs it in web browser.'
	game = gets.chomp
	if game == "1"
		puts "Command line game"
	elsif game == "2"
		puts "Web-based game"
		
	else
		puts "Invalid input! No game selected."
		exit
	end
		
	if game == "1"
		
	# Any code added to command line game should be added below.
	

	


		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	

	
	
	end
end



# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.
	

	#Creating the game object
	g=WOF_Game::Game.new(@input,@output)
	#Saving the name and the id of the student in a variable
	$credits=g.start
	get '/' do 
		erb :home
	end
	get '/new' do
		#Reading the file which contains all the words
		g.readwordfile("wordfile.txt")
		#Initializing the template and the secret word 
		secret = g.gensecretword
		g.setsecretword(secret)
		g.createtemplate
		$template=g.getsecrettemplate
		$secretword=g.getsecretword
		#Initializing the number of lives and the score and the letters array
		g.resetgame
		$score,$lives=g.getscore_lives
		$letters=g.getletters
		erb :new
	end
	get '/play' do
		erb :play
	end
	#The '/new' and '/play' pages are similar, with the difference that the '/new' page restarts the game and the variables completely 
	#Initializing the analysis message which will be displayed on the analysis page each time a game is finished
	$analysis_message=""
	get '/start' do
		$analysis_message=""
		erb :start
	end
	post '/start' do
		#Extracting the name which has been typed in the HTML input text box and saving it in a variable
		name=params[:name]
		#Adding the name of the player to the text file
		g.getname("names.txt",name)
		#Adding the name of the player to the analysis message
		$analysis_message+="Set name for player:#{name}<br>"
		redirect '/new'
	end	
	get '/leaderboard' do
		#Transferring all the information to a global variable which is used inside the "leaderboard" erb to display the leaderboard content
		$files=g.getleaderboardcontent("names.txt")
		erb :leaderboard
	end
	
	post '/new' do
		#Extracting the letter which has been typed in the HTML input text box and saving it in a variable
		letter=params[:letter].upcase
		#Adding the typed letter to the analysis message
		$analysis_message+="Player types letter: #{letter.upcase}<br>"
		#Eliminating the typed letter from the letters array
		g.eliminate_letter(letter)
		#Checking whether the typed letter is in the secret word or not 
		if g.checkifletter(letter)==true
			#If yes, update the template by showing the letter
			g.showcharinword(letter)
			#Appending an appropriate message to the analysis message string
			$analysis_message+=" Letter #{letter} is in the word<br>Update template <br>Update used letters <br>"
		else
			#If the letter has not been found in the secret word, update the lives and the score in accordance to the rules 
			g.updatescore_lives
			$analysis_message+="Letter #{letter} is not in the word <br>Update score<br>Update lives left<br>Update used letters<br>"
		end
		#Updating the template,score and lives variables and the letters array
		$template=g.getsecrettemplate
		$score,$lives=g.getscore_lives
		$letters=g.getletters
		redirect '/play'
	end

	post '/play' do
		#Extracting the letter which has been typed in the HTML input text box and saving it in a variable
		letter=params[:letter].upcase
		#Adding the typed letter to the analysis message
		$analysis_message+="Player types letter: #{letter.upcase}<br>"
		#Checking whether the letter has been already typed or not
		$used=g.letterinarray(letter) #Global variable used in the "play" erb for displaying an alert message
		if $used==true
			#Eliminating the typed letter from the letters array
			g.eliminate_letter(letter)
			#Checking whether the typed letter is in the secret word or not 
			if g.checkifletter(letter)==true
						#If yes, update the template by showing the letter
						g.showcharinword(letter)
						#Appending an appropriate message to the analysis message string
						$analysis_message+="Letter #{letter} is in the word<br>Update template <br>Update used letters <br>"
			else# Updating the score and the lives remaining ONLY if the typed letter has not been typed before
					g.updatescore_lives
					#Appending an appropriate message to the analysis message string
					$analysis_message+="Letter #{letter} is not in the word <br>Update score<br>Update lives left<br>Update used letters<br>"
			end
		else
			#Appending an appropriate message to the analysis message string
			$analysis_message+="Letter #{letter} has been already typed<br>Try another one!<br>"
		end
		if g.checkifwin or g.checkifloss
			if g.checkifwin # The player wins the game ONLY if the secret word and the initially provided template correspond
				#Setting the final analysis message accordingly 
				$analysis_message+="Word guessed!<br>You won!<br>Secret word:#{$secretword}<br>Your score:#{$score}<br>End of the game!<br>See your score inside the leaderboard!"
			end
			if g.checkifloss # The computer wins the game ONLY if the player runs out of lives
				#If the player loses, his/her score will be 0
				g.getscorezero
				$score=g.getscore_lives[0]
				#Setting the final analysis message accordingly
				$analysis_message+="You ran out of lives! <br>Computer won!<br>Secret word:#{$secretword}<br>Your score:#{$score}<br>End of the game!<br>See your score inside the leaderboard!"
			end
			g.getscore_secretword("names.txt")
			redirect '/leaderboard'
		end	
		#Updating the template,score and lives variables
		$template=g.getsecrettemplate
		$score,$lives=g.getscore_lives
		$letters=g.getletters
		redirect '/play'
	end
	post '/leaderboard' do
		redirect '/'
	end
	get '/analysis' do
		erb :analysis
	end
	
	get '/notfound' do
		erb :notfound
	end
	
	not_found do
		status 404
		redirect '/notfound'
	  end
	# Any code added to web-based game should be added above.

# End program