class Author
  attr_reader :id, :nickname, :name, :description, :posts, :comments_written

  def initialize(attributes = {})
    @id = attributes[:id]
    @nickname = attributes[:nickname]
    @name = attributes[:name]
    @description = attributes[:description]
    @posts = []
    @comments_written = attributes[:comments_written]
  end

  def add_post(post)
    @posts << post
    post.author = self
    post.author_id = self.id
  end
end
