require 'json'

word_bank = File.readlines('google-10000-english-no-swears.txt')

def get_random_word(words_arr)
  word = ''
  word = words_arr.sample until word.length >= 5 && word.length <= 12
  word
end

secret_word = get_random_word(word_bank)
secret_word_arr = Array.new(secret_word.length - 1, 0)

def display_word(word, display_arr)
  display_arr.each_with_index { |x, index| print x == 1 ? word[index] : '_' }
  puts "\n\n"
end

puts secret_word

STICKMAN_PIECES = [' O', '/|\\', ' |', '/ \\']

def print_stick_man(form_num)
  case form_num
  when 0
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts STICKMAN_PIECES[3]
  when 1
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts ' ' + STICKMAN_PIECES[3][1...]
  when 2
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts # new line
  when 3
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts # new line
    puts # new line
  when 4
    puts STICKMAN_PIECES[0]
    puts ' ' + STICKMAN_PIECES[1][1...]
    puts # new line
    puts # new line
  when 5
    puts STICKMAN_PIECES[0]
    puts ' ' + STICKMAN_PIECES[1][1...2]
    puts # new line
    puts # new line
  when 6
    puts STICKMAN_PIECES[0]
    puts # new line
    puts # new line
    puts # new line
  else
    puts # new line
  end
end

def process_letter(word, word_arr, letter)
  word_arr.each_with_index { |x, index| word_arr[index] = 1 if word[index] == letter }
end

def display_game_board(remaining_lives, word, word_arr, guessed_letters)
  print_stick_man(remaining_lives)
  display_word(word, word_arr)
  puts "Guessed Letters: [' #{guessed_letters.join(', ')} ']"
end

def run_game(word, word_arr)
  remaining_lives = 7
  won = false
  saved = false
  guessed_letters = []

  while (remaining_lives > 0) && (won == false) && (saved == false)
    display_game_board(remaining_lives, word, word_arr, guessed_letters)

    print 'Your Guess (\'*\' to save & quit): '
    user_guess = gets.chomp[0]

    if user_guess == '*'
      save_game(word, word_arr, remaining_lives, guessed_letters)
      saved = true
    end

    if user_guess.nil? || !user_guess.match?(/[[:alpha:]]/) || guessed_letters.include?(user_guess.downcase)
      puts '-------------------------------------'
      next
    end

    next if saved

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

def save_game(word, word_arr, remaining_lives, guessed_letters)
  game_hash = { word: word.chomp, word_arr: word_arr, remaining_lives: remaining_lives,
                guessed_letters: guessed_letters }
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

  file_counter = 1
  file_name = 'saved_games/game.json'

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

  file_counter = 1
  saved_games = []
  Dir.foreach('saved_games') do |file_name|
    next if ['.', '..'].include?(file_name)

    saved_games.append(file_name)
    puts "#{file_counter}. #{file_name}"
    file_counter += 1
  end

  print 'Choice: '
  user_choice = gets.chomp

  begin
    raise StandardError if user_choice.to_i > saved_games.size || user_choice.to_i < 1

    file_to_load = File.new("saved_games/#{saved_games[user_choice.to_i - 1]}", 'r')
  rescue StandardError
    'Invalid Choice'
  end

  if file_to_load.nil?
    puts 'Invalid Choice'
    return
  end

  puts file_to_load.read
end

# run_game(secret_word, secret_word_arr)
load_game
