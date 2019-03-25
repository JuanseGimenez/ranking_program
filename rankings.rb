class League
  attr_accessor :teams, :matches

  def initialize(teams = [], matches = [])
    @teams   = teams.map { |team| Team.new(team) } 
    @matches = matches.map { |match| add_match_results(match)}
  end

  def add_match_results(match)
  	# TODO
  end

  def winner
  	# TODO
  end

  def scoreboard
  	# TODO
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