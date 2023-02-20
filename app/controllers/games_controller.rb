class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters.push(("A".."Z").to_a.sample) }
  end

  def score
    letters = params[:letters].split(" ")
    @entered_word = params[:word]
    @result = ""
    parsed_word = parse_info(@entered_word)

    # The word can’t be built out of the original grid
    if part_of_grid?(@entered_word.upcase.chars, letters) == false
      @result = "Sorry but #{@entered_word} can't be built out of #{letters}"
    # The word is valid according to the grid, but is not a valid English word
    elsif valid_english_word?(parsed_word) == false
      @result = "Sorry but #{@entered_word} is not an English word"
    # The word is valid according to the grid and is an English word
    else
      @result = "Congratulations! #{@entered_word} is a valid English word"
    end
  end

  def parse_info(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    read_url = URI.open(url).read
    parsed_info = JSON.parse(read_url)
    return parsed_info
  end

  def valid_english_word?(parsed_word_info)
    if parsed_word_info["found"] == true
      return true
    else
      return false
    end
  end

  def part_of_grid?(word_array, letter_grid)
    word_array.all? do |letter| # validate if the attempt is inside the grid array
      if letter_grid.include?(letter.to_s)
        letter_grid.delete_at(letter_grid.index(letter))
        true
      else
        false
      end
    end
  end
end
