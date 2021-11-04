require_relative 'author_repository'
require_relative 'post'
require 'csv'
require 'pry-byebug'

class PostRepository
  def initialize(csv_file)
    @posts = []
    @csv_file = csv_file
    @next_id = 1
    @authors_repo = AuthorRepository.new('lib/authors.csv')
    load_csv if File.exist?(@csv_file)
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

  def destroy(index)
    # binding.pry
    @posts.delete_at(index)
    save
  end

  def get_posts_by_author(author_id)
    @posts.select { |a| a.author_id == author_id }
  end

  private

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      # binding.pry
      @posts << Post.new({ path: row[0], title: row[1], content: row[2],
                           author: @authors_repo.find(row[6].to_i), read: row[4] == 'true', id: row[5].to_i,
                           author_id: row[6].to_i })
    end
    @next_id = @posts.empty? ? 1 : @posts.last.id + 1
    # binding.pry
    @posts
  end

  def save
    csv_options = { col_sep: ',', headers: :first_row }
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      csv << %w[path title content author read id author_id]
      @posts.each do |pt|
        # binding.pry
        csv << [pt.path, pt.title, pt.content, pt.author.name, pt.read?, pt.id, pt.author_id]
      end
    end
  end
end

# posts = PostRepository.new('lib/posts.csv')
# binding.pry
# p posts.all[0].id
# p posts.all[1].id
# p posts.all[2].id
