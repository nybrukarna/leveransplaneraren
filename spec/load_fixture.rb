class LoadFixture
  def initialize(name)
    @filename = name
    file_path = Dir[File.expand_path(File.dirname(__FILE__) + "fixtures/#{@filename}")]
    @data = File.readlines(file_path).each do |line|
      line.split(',')
    end
  end

  def [](col, row)
    @data[col, row]
  end

  def inspect
    p @data
  end
end

