namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
  User.create!(name: "amk",
               email: "amk@amk.amk",
               password: "amkamk",
               password_confirmation: "amkamk",
							 admin: true,
               notify_following: true)
  5.times do |n|
    name  = Faker::Internet.user_name
    email = Faker::Internet.email
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  5.times do |n|
	  for m in 1..User.count do
		  content = Faker::Lorem.sentence(5)
      if ((n+m) % 5 == 0)
        content.insert(0, "DM @#{User.where("id > ?", m % User.count).first.name} ")
      elsif ((n+m) % 5 == 2)
        content.insert(0, "@#{User.where("id > ?", (m+1) % User.count).first.name} ")
      end
		  User.find(m).microposts.create!(content: content)
    end
	end
end

def make_relationships
	users = User.all
	user  = users.first
	followed_users = users[3..User.count]
	followers			 = users[2..User.count]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each			{ |follower| follower.follow!(user) }
end
