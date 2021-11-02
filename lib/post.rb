class Post
  attr_reader :title, :path, :content
  attr_accessor :author, :author_id, :id

  def initialize(attributes = {})
    @id = attributes[:id]
    @path = attributes[:path]
    @title = attributes[:title]
    @content = attributes[:content]
    @author = attributes[:author]
    @author_id = attributes[:author_id]
    @read = attributes[:read] == "true"
  end

  def read?
    @read
  end

  def to_s
    "#{title} (#{author})\n\n#{content}"
  end

  def mark_as_read!
    @read = true
  end
end
