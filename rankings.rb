class FileParser
	attr_accessor :filepath, :filecontent

	def initialize(name)
    @filepath = name
  end

  private

  def parse_file
    @filecontent ||= File.read(@filepath)
  end
end