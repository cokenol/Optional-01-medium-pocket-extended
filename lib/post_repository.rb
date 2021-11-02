require_relative 'author_repository'
require_relative 'post'
require 'csv'
require 'pry-byebug'

class PostRepository
  def initialize(csv_file)
    @posts = []
    @csv_file = csv_file
    @next_id = 1
    @authors_repo = AuthorRepository.new('authors.csv')
    load_csv if File.exist?(@csv_file)
    # save
  end

  def all
    @posts
  end

  def add(post)
    post.id = @next_id
    @next_id += 1
    @posts << post
    save
  end

  def find(index)
    @posts[index]
  end

  def mark_as_read(index)
    @posts[index].mark_as_read!
    save
  end

  private

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      # binding.pry
      @posts << Post.new(
        path: row[0], title: row[1], content: row[2],
        author: row[3], read: row[4] == 'true', id: row[5].to_i
      )
    end
    # binding.pry
    @next_id = @posts.empty? ? 1 : @posts.last.id + 1
    @posts
  end

  def save
    csv_options = { col_sep: ',', headers: true }
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      csv << %w[path title content author read id]
      @posts.each do |post|
        csv << [post.path, post.title, post.content, post.author, post.read?, post.id]
      end
    end
  end
end

# posts = PostRepository.new('lib/posts.csv')
# binding.pry
# p posts.all[0].id
# p posts.all[1].id
# p posts.all[2].id
