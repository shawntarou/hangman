word_bank = File.readlines('google-10000-english-no-swears.txt')

def get_random_word(words_arr)
  word = ""
  until word.length >= 5 && word.length <= 12
        word = words_arr.sample
  end 
  return word
end

secret_word = get_random_word(word_bank)
puts (secret_word)