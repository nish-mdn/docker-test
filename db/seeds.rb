post = Post.create!(title: "Welcome to Rails Blog", body: "This is your first post created by seeds.")
post.comments.create!(body: "First comment!")
post.comments.create!(body: "Second comment, hello!")
