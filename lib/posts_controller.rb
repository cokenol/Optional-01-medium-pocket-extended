require "open-uri"
require "nokogiri"

require_relative "view"

class PostsController
  BASE_URL = "https://dev.to/".freeze

  def initialize(repo, author_repo)
    @repo = repo
    @view = View.new
    @author_repo = author_repo
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

  private

  def list
    posts = @repo.all
    @view.display(posts)
  end

  def scrape_post(doc)
    # scrape title content author authorpath
    paragraphs = doc.search("#article-body p")
    title = doc.search("h1").first.text.strip
    content = paragraphs.map(&:text).join("\n\n")
    # author = doc.search(".crayons-article__subheader a").text.strip
    author_path = doc.search('.crayons-article__header__meta a.crayons-link')[0]["href"]
    # create new author in author repo. save in that csv and return author_id.
    author_instance = scrape_author(author_path)
    @author_repo.add(author_instance)
    # create new posts and use that author_id to save in csv
    [Post.new({ path: author_path, title: title, content: content,
               author: author_instance, author_id: author_instance.id }), author_instance]
  end

  def scrape_author(author_path)
    # go authorpath scrape nickname description posts_published comments_written
    author_doc = Nokogiri::HTML(URI.open("#{BASE_URL}#{author_path}").read)
    author = author_doc.search('.profile-header__details h1').first.text.strip
    nickname = author_path.scan(/\w+/)[0]
    description = author_doc.search('.profile-header__details p').first.text.strip
    posts_published = author_doc.search('.crayons-story__title a')[0..4].text.strip.split(/\n\s+{2}/)
    comments_written = author_doc.search('.profile-comment-row p.color-base-80')[0..4].text.strip.split(/\n\s+{2}/)
    # create new author in author repo. save in that csv and return author_id.
    Author.new({ nickname: nickname, name: author, description: description,
                 posts: posts_published, comments_written: comments_written })
  end
end
# author_doc = Nokogiri::HTML(File.open("./aspittel.html")) #to test
# description = author_doc.search('.profile-header__details p').first.text.strip
# posts_published = author_doc.search('.crayons-story__title a')[0..4].text.strip.split(/\n\s+{2}/)
# comments_written = author_doc.search('.profile-comment-row p.color-base-80')[0..4].text.strip.split(/\n\s+{2}/)
# author = author_doc.search('.profile-header__details h1').first.text.strip

# p description
# p posts_published
# p comments_written
# p author
