require 'open-uri'
require 'json'
require 'time'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  grid_array = []
  grid_size.times { grid_array << [*'A'..'Z'].sample }
  grid_array
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  time_taken = end_time - start_time
  if word_checker(attempt) && in_the_grid(attempt, grid)
    return { time: time_taken, score: (attempt.size * 100) - (time_taken * 10), message: "well done" }
  elsif word_checker(attempt) == false && in_the_grid(attempt, grid) == true
    return { time: (end_time - start_time), score: 0, message: "not an english word" }
  else # word_checker(attempt) == true && in_the_grid(attempt, grid) == false
    return { time: (end_time - start_time), score: 0, message: "that's not in the grid" }
  end
  # result = { time: 10, score: 100, message: "Good job" }
  # p result
end

def word_checker(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  word_serialized = open(url).read
  word = JSON.parse(word_serialized)
  word["found"]
end

def in_the_grid(attempt, grid)
  check = true
  attempt.upcase.chars.each do |letter|
    check = false unless grid.include? letter
    grid.delete(letter)
  end
  check
end

# p word_checker("swaggers")
# grid_checker(generate_grid(9), "welcome")
# grid_checker(["W","E","L","C","O","M","E","E","M"], "welcome")
# p run_game("WELCOME", ["W", "E", "L", "C", "O", "M", "E", "E", "M"], 10, 15)
# p run_game("HOI", ["H", "O", "I", "C", "O", "M", "E", "E", "M"], 10, 15)


# def grid_checker(grid, attempt)
#   # idea, make an hash of the complete alphabet, let them add if key in grid, deduct
#   # when in attempt. Values < 0 is an error
#   alphabet_hash = Hash.new(0)
#   alphabet_array = [*"A".."Z"]
#   alphabet_array.group_by(&:itself).each { |k, v| alphabet_hash[k] = 0 }
#   alphabet_hash
#   grid_hash = {}
#   attempt_hash = {}
#   attempt_array = attempt.chars
#   grid.group_by(&:itself).each { |k, v| grid_hash[k] = v.length }
#   attempt_array.group_by(&:itself).each { |k, v| attempt_hash[k] = v.length }
#   # p grid_hash
#   # p attempt_hash
#   # p attempt_array
#   # difference = (grid_hash.to_a - attempt_hash.to_a).to_h
#   # p difference
#   p sum_hash = (alphabet_hash.to_a + grid_hash.to_a).to_h
#   attempt_hash.each do |k, v|
#     sum_hash[k] = sum_hash[sum_hash[k]] - attempt_hash[v]
#   end
#   p sum_hash
# end
