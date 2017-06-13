# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
ya = Template.create! :name => "Glorious Blogger" , :content => ""
Article.create! :title => "Humor", :content => "<img class=\"wireframe\" src=\"https://semantic-ui.com/examples/assets/images/wireframe/media-paragraph.png\">"
Page.create! :content => " <h1 class=\"ui header\">Semantic UI Fixed Template</h1> <p>This is a basic fixed menu template using fixed size containers.</p><p>A text container is used for the main container, which is useful for single column layouts</p><div class=\"article-area\"></div>", :template => ya, :name => 'homepage'
