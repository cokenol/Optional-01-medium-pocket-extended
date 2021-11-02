require 'csv'
require_relative 'author'
require 'pry-byebug'

class AuthorRepository
  def initialize(csv_file)
    @authors = []
    @csv_file = csv_file
    @next_id = 1
    load_csv if File.exist?(@csv_file)
    # save
  end

  def all
    @authors
  end

  def add(author)
    author.id = @next_id
    @next_id += 1
    @authors << author
    save
  end

  def find_by_index(index)
    @authors[index]
  end

  def find(id)
    @authors.find { |a| a.id == id }
  end

  def mark_as_read(index)
    @authors[index].mark_as_read!
    save
  end

  private

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      # binding.pry
      @authors << Author.new(
        id: row[0].to_i, nickname: row[1], name: row[2],
        description: row[3], posts: row[4], comments_written: row[5]
      )
    end
    # binding.pry
    @next_id = @authors.empty? ? 1 : @authors.last.id + 1
    @authors
  end

  def save
    csv_options = { col_sep: ',', headers: true }
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      csv << %w[id nickname name description posts comments_written]
      @authors.each do |a|
        csv << [a.id, a.nickname, a.name, a.description, a.posts, a.comments_written]
      end
    end
  end
end

# authors = AuthorRepository.new('lib/authors.csv')
# binding.pry
# p authors.all[0].id
# p authors.all[1].id
# p authors.all[2].id
