require "open-uri"
require "nokogiri"

require_relative "view"

class AuthorsController
  BASE_URL = "https://dev.to/".freeze

  def initialize(repo, post_repo)
    @repo = repo
    @view = View.new
    @post_repo = post_repo
  end

  def index
    list
  end

  def create
    path = @view.ask_user_for(:path)
    file = URI.open("#{BASE_URL}#{path}").read
    doc = Nokogiri::HTML(file)
    post = scrape_post(doc)[0]
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

  def list_authors_posts
    list
    index = @view.ask_user_for_index
    author_id = @repo.get_author_id(index)
    posts = @post_repo.get_posts_by_author(author_id)
    @view.display(posts)
  end

  private

  def list
    authors = @repo.all
    @view.display_authors(authors)
  end
end
