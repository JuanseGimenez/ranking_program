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