class PagesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'time'

  def game
    @grid = generate_grid(10)
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @start_time2 = params[:game_start]
    @grid2 = params[:u_grid]
    @answer = params[:word]
    @score = run_game(@answer, @grid2, @start_time2, @end_time)
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0) * 100
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: (end_time.to_time - start_time.to_time) }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time).to_i
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
