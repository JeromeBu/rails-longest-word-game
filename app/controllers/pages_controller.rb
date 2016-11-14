class PagesController < ApplicationController


  require 'open-uri'
  require 'json'

  WORDS = File.read('/usr/share/dict/words').upcase.split("\n")


  def start_game
    @grid = generate_grid(9)
    @start_time = Time.now
  end

  def give_score
    end_time = Time.now
    @results = run_game(params[:attempt], params[:grid].split, Time.parse(params[:start_time]), end_time)
  end



  # result = run_game(attempt, grid, start_time, end_time)





  private


  def english?(attempt)
     WORDS.include? attempt.upcase
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    alphabet = ("A".."Z").to_a
    grid = []
    grid_size.times { grid << alphabet.sample }
    grid
  end

  def in_grid?(attempt, grid)
    hashed_grid = {}
    grid.each do |let|
      if hashed_grid.key?(let.downcase)
        hashed_grid[let.downcase] += 1
      else
        hashed_grid[let.downcase] = 1
      end
    end

    attempt.downcase.split("").each do |letter|
      if hashed_grid.key?(letter)
        hashed_grid[letter] == 1 ? hashed_grid.delete(letter) : hashed_grid[letter] -= 1
      else
        return false
      end
    end
    return true
  end




  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=542c2ef6-9430-4418-800e-20a52d2ee74f&input=#{attempt}"
    serialized = open(url).read
    hash = JSON.parse(serialized)
    time = end_time - start_time
    score = 10.0 * (attempt.length.to_f / 9.0) + 1.0 / time
    translation = hash["outputs"][0]["output"]
    if in_grid?(attempt, grid)
      message = "well done"
      unless english?(attempt)
        score = 0
        message = "not an english word"
        translation = nil
      end
    else
      score = 0
      message = "not in the grid"
    end
    { attempt: attempt, time: time, translation: translation, score: score, message: message }
  end

  # p run_game("cark", %w(C T E P R A), Time.now, Time.now + 1000)


end
