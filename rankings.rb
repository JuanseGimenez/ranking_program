class TestSuite
  def expect(scenario, expectation)
    if scenario != expectation
      puts "Failed scenario: #{scenario} to be #{expectation}"
    else
      puts "Success scenario: #{scenario} to be #{expectation}"
    end
  end
end

class League
  attr_accessor :teams, :matches

  def initialize(teams = [], matches = [])
    @teams   = teams.map { |team| Team.new(team) } 
    @matches = matches.map { |match| add_match_results(match)}
  end

  def add_match_results(match)
  	if match[0][1] == match[1][1] 
      team1 = @teams.find {|team| team.name == match[0][0]}
      team2 = @teams.find {|team| team.name == match[1][0]}

      team1.score += 1
      team2.score += 1
    else
      winner = match.max_by { |x| x[1] }
      losser = match.min_by { |x| x[1] }

      team1 = @teams.find {|team| team.name == winner[0]}
      team2 = @teams.find {|team| team.name == losser[0]}

      team1.score += 3 
    end
    team1.goals += match[0][1].to_i
    team2.goals += match[1][1].to_i
  end

  def winner
  	scoreboard.first
  end

  def scoreboard
  	teams.sort { |team1, team2| team1.score == team2.score ? team1.name <=> team2.name : team2.score <=> team1.score }.each_with_object([]) do |team, scoreboard|
      scoreboard << { name: team.name, score: team.score, goals: team.goals }
    end
  end
end

class Team
  attr_accessor :name, :score, :goals

  def initialize(name)
  	@name  = name
  	@score = 0
  	@goals = 0
  end
end

class FileParser
	attr_accessor :filepath, :filecontent

	REGEXP = {
    name: /^\w+\s?\w+[:digits:]/,
    score: /\d+/,
    name_and_score: /(\w+\s?\w+)\s(\d)/
  }

	def initialize(name)
    @filepath = name
  end

  def teams
    parse_file.lines.each_with_object([]) do |line, matches|
      teams = line.strip.split(',')
      teams.each {|team| matches << team.scan(REGEXP[:name_and_score])}
    end.map{|v| v[0][0] }.uniq
  end

  def matches
    parse_file.lines.each_with_object([]) do |line, matches|
      matches << line.scan(REGEXP[:name_and_score])
    end
  end

  def show_board(board)
    board.each_with_index do |team, index|
      puts "#{index + 1}. #{team[:name]}, #{team[:score]} pts"
    end
  end

  def export_board(board)
    file = File.open("output.txt", "w")
    board.each_with_index do |team, index|
      file.puts "#{index + 1}. #{team[:name]}, #{team[:score]} pts"
    end
  end

  private

  def parse_file
    @filecontent ||= File.read(@filepath)
  end
end

file   = FileParser.new('input.txt')
league = League.new(file.teams, file.matches)
file.show_board(league.scoreboard)
file.export_board(league.scoreboard)

test = TestSuite.new
test.expect(league.winner[:name], "Lions")
test.expect(league.scoreboard, [{:name=>"Lions", :score=>7, :goals=>9},
																{:name=>"Tarantulas", :score=>7, :goals=>5},
																{:name=>"FC Awesome", :score=>4, :goals=>4},
																{:name=>"Snakes", :score=>3, :goals=>10},
																{:name=>"Grouches", :score=>1, :goals=>3}])
test.expect(file.teams, ["Lions", "Snakes", "Tarantulas", "FC Awesome", "Grouches"])
test.expect(file.matches, [[["Lions", "4"], ["Snakes", "3"]],
													 [["Tarantulas", "1"], ["FC Awesome", "0"]],
													 [["Lions", "1"], ["FC Awesome", "1"]],
													 [["Tarantulas", "3"], ["Snakes", "1"]],
													 [["Lions", "4"], ["Grouches", "0"]],
													 [["Tarantulas", "1"], ["Grouches", "1"]],
													 [["Snakes", "4"], ["Grouches", "2"]],
													 [["FC Awesome", "3"], ["Snakes", "2"]]])