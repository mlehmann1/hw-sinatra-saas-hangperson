class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @num_guesses = 0
  end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess l 
    if l.nil?
      raise ArgumentError.new("Issue with arguments")
    end
    letter = l.downcase
    if (/[^a-z$]/.match(letter)) || (letter.empty?)
      raise ArgumentError.new("Issue with arguments")
    end
    if (word.include? letter) && (!guesses.include? letter)
      guesses.concat(letter) 
      true
    elsif (!word.include? letter) && (!wrong_guesses.include? letter)
      wrong_guesses.concat(letter) 
      @num_guesses += 1
      true
    elsif (guesses.include? letter) || (wrong_guesses.include? letter)
      false
    end
  end 
  
  def word_with_guesses
    retWord = ""
    word.split("").each do |x|
      if guesses.include? x
        retWord.concat(x)
      else
        retWord.concat("-")
      end
    end
    retWord
  end
  
  def check_win_or_lose
    if @num_guesses > 6
      :lose
    elsif word == word_with_guesses
      :win
    else
      :play
    end
  end
end
