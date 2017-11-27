require 'open-uri'
require 'json'

class GamesControllerController < ApplicationController

  def game
    grid_size = 10
    @start_time = Time.now

    #Making a new grid
    def generate_grid(grid_size)
      new_grid = ""; grid_size.times { new_grid << (65 + rand(25)).chr }
      return new_grid.split("")
    end

    @grid = generate_grid(grid_size)

  end

  def score
    @answer = params[:answer]
    grid = params[:grid].split("")
    end_time = Time.now
    start_time = Time.parse(params[:time])

    #Running the game
    def run_game(attempt, grid, start_time, end_time)
      attempt_array = attempt.upcase.split("")
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      attempt_serialized = open(url).read
      attempt_player = JSON.parse(attempt_serialized)
      grid_length = grid.length

      attempt_array.each do |letter|
        grid.include?(letter) ? grid.delete_at(grid.find_index(letter)) : nil
      end

      if (grid_length - grid.length) == attempt_array.length
        if attempt_player["found"]
          result = {  answer: attempt,
                      time: (end_time - start_time).round(1),
                      score: attempt_player["word"].length**2 - (end_time - start_time).round + 10,
                      message: "Well done!" }
        else
          result = { answer: attempt, time: (end_time - start_time).round(1), score: 0, message: "You word is not an english word!" }
        end
      else
        result = { answer: attempt, time: (end_time - start_time).round(1), score: 0, message: "You used letters that were not in the grid!" }
      end
      return result
    end
    @result = run_game(@answer, grid, start_time, end_time)
  end
end
