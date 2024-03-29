class Router
  def initialize(post_ctrl, author_ctrl)
    @posts_controller = post_ctrl
    @authors_controller = author_ctrl
    @running = true
  end

  def run
    print `clear`
    puts '---------------------------------'
    puts 'Welcome to your DEV Pocket Reader'
    puts '---------------------------------\n\n'
    while @running
      print_menu
      action = gets.chomp.to_i
      print `clear`
      route(action)
    end
    puts 'Bye bye!'
  end

  private

  def print_menu
    puts '----------------------------'
    puts 'What do you want to do next?'
    puts '----------------------------'
    puts '1. List posts'
    puts '2. Save post for later'
    puts '3. Read post'
    puts '4. Mark post as read'
    puts '5. Delete post'
    puts '6. List authors'
    puts '7. List authors\'s posts'
    puts '8. See author info'
    puts '9. Exit'
    print '> '
  end

  def route(action)
    case action
    when 1 then @posts_controller.index
    when 2 then @posts_controller.create
    when 3 then @posts_controller.show
    when 4 then @posts_controller.mark_as_read
    when 5 then @posts_controller.destroy
    when 6 then @authors_controller.index
    when 7 then @authors_controller.list_authors_posts
    when 8 then @authors_controller.see_author_info
    when 9 then @running = false
    else
      puts 'Try again'
    end
  end
end
