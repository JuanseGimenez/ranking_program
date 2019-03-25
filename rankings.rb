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
  	# TODO
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

  private

  def parse_file
    @filecontent ||= File.read(@filepath)
  end
end