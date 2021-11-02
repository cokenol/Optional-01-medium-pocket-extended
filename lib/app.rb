require_relative "post_repository"
require_relative "posts_controller"
require_relative "router"

repo = PostRepository.new(File.join(__dir__, 'posts.csv'))
posts_controller = PostsController.new(repo)
router = Router.new(posts_controller)
router.run
