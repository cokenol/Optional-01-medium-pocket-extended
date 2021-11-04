require 'pry-byebug'

class Author
  attr_reader :nickname, :name, :description, :posts, :comments_written
  attr_accessor :id

  def initialize(attributes = {})
    # binding.pry
    @id = attributes[:id]
    @nickname = attributes[:nickname]
    @name = attributes[:name]
    @description = attributes[:description]
    @posts = attributes[:posts]
    @comments_written = attributes[:comments_written]
  end

  def add_post(post)
    @posts << post
    post.author = self
    post.author_id = id
  end
end
