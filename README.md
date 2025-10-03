rails_blog_full - Rails 7 starter (Posts + Comments) with Dockerfile included

Quick run (requires Docker and a running MySQL container named 'db'):

  docker build -t rails-blog .
  docker run -d --name db -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=blog_dev mysql:8
  docker run -it --rm --name rails-app -p 3000:3000 --link db:db -e DB_HOST=db rails-blog

The app includes bin/ executables and minimal assets folders to avoid Sprockets errors.
