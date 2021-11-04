require 'pry-byebug'

class View
  def display(posts)
    posts.each_with_index do |post, index|
      status = post.read? ? "[x]" : "[ ]"
      # binding.pry
      puts "#{index + 1}. #{status} - #{post.title} (#{post.author.name})"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_index
    puts "Index?"
    print "> "
    return gets.chomp.to_i - 1
  end

  def display_content(post)
    puts post # calls `post.to_s`!
  end

  def display_authors(authors)
    authors.each_with_index do |a, index|
      puts "#{index + 1}. #{a.name}"
    end
  end
end
