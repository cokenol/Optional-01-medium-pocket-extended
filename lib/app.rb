require_relative "post_repository"
require_relative "posts_controller"

require_relative "author_repository"
require_relative "authors_controller"
require_relative "router"

post_repo = PostRepository.new(File.join(__dir__, 'posts.csv'))
author_repo = AuthorRepository.new(File.join(__dir__, 'authors.csv'))
posts_controller = PostsController.new(post_repo, author_repo)
authors_controller = AuthorsController.new(author_repo, post_repo)
router = Router.new(posts_controller, authors_controller)
router.run
