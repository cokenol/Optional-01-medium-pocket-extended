require "open-uri"
require "nokogiri"

require_relative "view"

class PostsController
  BASE_URL = "https://dev.to/".freeze

  def initialize(repo)
    @repo = repo
    @view = View.new
  end

  def index
    list
  end

  def create
    path = @view.ask_user_for(:path)
    file = URI.open("#{BASE_URL}#{path}").read
    doc = Nokogiri::HTML(file)
    title = doc.search("h1").first.text.strip
    paragraphs = doc.search("#article-body p")
    content = paragraphs.map(&:text).join("\n\n")
    author = doc.search(".crayons-article__subheader a").text.strip
    author_path = doc.search('.crayons-article__header__meta a.crayons-link')[0]["href"]
    # author_doc = Nokogiri::HTML(URI.open("#{BASE_URL}#{author_path}").read)
    author_doc = Nokogiri::HTML(File.open("./aspittel.html")) #to test
    nickname = author_path.scan(/\w+/)
    description = author_doc.search('.profile_header__details p').first.text.strip
    binding.pry
    post = Post.new(path: path, title: title, content: content, author: Author.new({ author: author }))
    @repo.add(post)
    list
  end

  def show
    list
    index = @view.ask_user_for_index
    post = @repo.find(index)
    @view.display_content(post)
  end

  def mark_as_read
    list
    index = @view.ask_user_for_index
    @repo.delete(index)
    list
  end

  def destroy
    list
    index = @view.ask_user_for_index
    @repo.destroy(index)
    list
  end

  private

  def list
    posts = @repo.all
    @view.display(posts)
  end
end


author_doc = Nokogiri::HTML(File.open("./aspittel.html")) #to test
description = author_doc.search('.profile-header__details p').first.text.strip
posts_published = author_doc.search('.crayons-story__title a')[0].text.strip
comments_written = author_doc.search('.profile-comment-row p.color-base-80').first.text.strip

p description
p posts_published
p comments_written
