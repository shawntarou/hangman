require 'json'

word_bank = File.readlines('google-10000-english-no-swears.txt')

def get_random_word(words_arr)
  word = ''
  word = words_arr.sample until word.length >= 5 && word.length <= 12
  word
end

def display_word(word, display_arr)
  display_arr.each_with_index { |x, index| print x == 1 ? word[index] : '_' }
  puts "\n\n"
end

def print_stick_man(form_num)
  stickman_pieces = [' O', '/|\\', ' |', '/ \\']

  case form_num
  when 0
    puts stickman_pieces[0]
    puts stickman_pieces[1]
    puts stickman_pieces[2]
    puts stickman_pieces[3]
  when 1
    puts stickman_pieces[0]
    puts stickman_pieces[1]
    puts stickman_pieces[2]
    puts ' ' + stickman_pieces[3][1...]
  when 2
    puts stickman_pieces[0]
    puts stickman_pieces[1]
    puts stickman_pieces[2]
    puts # new line
  when 3
    puts stickman_pieces[0]
    puts stickman_pieces[1]
    puts # new line
    puts # new line
  when 4
    puts stickman_pieces[0]
    puts ' ' + stickman_pieces[1][1...]
    puts # new line
    puts # new line
  when 5
    puts stickman_pieces[0]
    puts ' ' + stickman_pieces[1][1...2]
    puts # new line
    puts # new line
  when 6
    puts stickman_pieces[0]
    puts # new line
    puts # new line
    puts # new line
  else
    puts # new line
  end
end

def run_game(word, word_arr, remaining_lives = 7, guessed_letters = [])
  won = false
  saved = false

  while (remaining_lives > 0) && (won == false) && (saved == false)
    display_game_board(remaining_lives, word, word_arr, guessed_letters)

    user_guess = get_user_guess(guessed_letters)

    if user_guess == '*'
      save_game(word, word_arr, remaining_lives, guessed_letters)
      saved = true
    end

    break if saved

    user_guess = user_guess.downcase
    guessed_letters.append(user_guess)

    if word.include?(user_guess[0])
      process_letter(word, word_arr, user_guess)
    else
      remaining_lives -= 1
    end

    if word_arr.all?(1) then (won = true) end

    puts '-------------------------------------'
  end

  if saved == true
    puts "\nGAME SAVED!"
  elsif won == true
    display_game_board(remaining_lives, word, word_arr, guessed_letters)
    puts "\nYOU WIN! The Secret Word was #{word}"
  else
    display_game_board(remaining_lives, word, word_arr, guessed_letters)
    puts "\nYOU LOSE! The Secret Word was #{word}"
  end
end

def get_user_guess(guessed_letters)
  user_guess = ''
  loop do
    print 'Your Guess (\'*\' to save & quit): '
    user_guess = gets.chomp[0]

    break if user_guess == '*'

    if user_guess.nil? || !user_guess.match?(/[[:alpha:]]/) || guessed_letters.include?(user_guess.downcase)
      puts '-------------------------------------'
      next
    end

    break
  end
  user_guess
end

def display_game_board(remaining_lives, word, word_arr, guessed_letters)
  print_stick_man(remaining_lives)
  display_word(word, word_arr)
  puts "Guessed Letters: [ #{guessed_letters.join(', ')} ]"
end

def process_letter(word, word_arr, letter)
  word_arr.each_with_index { |x, index| word_arr[index] = 1 if word[index] == letter }
end

def save_game(word, word_arr, remaining_lives, guessed_letters)
  game_hash = { word: word.chomp, word_arr: word_arr, remaining_lives: remaining_lives,
                guessed_letters: guessed_letters }
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

  file_counter = 1
  file_name = 'saved_games/game_1.json'

  while File.exist?(file_name)
    file_name = "saved_games/game_#{file_counter}.json"
    file_counter += 1
  end

  File.open(file_name, 'w') do |file|
    file.write(JSON.generate(game_hash))
  end
end

def load_game
  unless Dir.exist?('saved_games')
    puts 'No Saved Games'
    return
  end

  saved_games = []
  file_to_load = nil

  loop do
    print_saved_games
    saved_games = store_saved_games(saved_games)

    print "\n> "
    user_choice = gets.chomp
    puts # new line
    raise StandardError if user_choice.to_i > saved_games.size || user_choice.to_i < 1

    file_to_load = File.new("saved_games/#{saved_games[user_choice.to_i - 1]}", 'r')
    raise StandardError if file_to_load.nil?
  rescue StandardError
    'Invalid Choice'
  else
    break unless file_to_load.nil?
  end

  saved_data = file_to_load.read
  saved_data = JSON.parse saved_data.gsub('=>', ':')

  run_game(saved_data['word'], saved_data['word_arr'], saved_data['remaining_lives'], saved_data['guessed_letters'])
end

def print_saved_games
  file_counter = 1
  puts 'Select Game File: '

  Dir.foreach('saved_games') do |file_name|
    next if ['.', '..'].include?(file_name)

    puts "#{file_counter}. #{file_name}"
    file_counter += 1
  end
end

def store_saved_games(saved_games)
  Dir.foreach('saved_games') do |file_name|
    next if ['.', '..'].include?(file_name)

    saved_games.append(file_name) unless saved_games.include?(file_name)
  end

  saved_games
end

def print_menu
  puts " - H A N G M A N - \n"
  puts '1. New Game'
  puts '2. Load Game'
  print "\n> "
end

user_menu_choice = -1

loop do
  print_menu
  user_menu_choice = gets.chomp.to_i

  break if [1, 2].include?(user_menu_choice)
end

puts # new line

case user_menu_choice
when 1
  secret_word = get_random_word(word_bank)
  secret_word_arr = Array.new(secret_word.length - 1, 0)
  run_game(secret_word, secret_word_arr)
when 2
  load_game
else
  'ERROR'
end
