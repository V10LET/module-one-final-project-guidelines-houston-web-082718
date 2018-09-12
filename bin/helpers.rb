def create_snowman(name)
  Snowman.create(name: name)
end

def create_friend(name, snowman)
  Friend.create(name: name, snowman_id: snowman.id)
end

def sanitize_price(price)
  price.tr('^0-9\.', '')
end

def create_gift(name, price, snowman)
  Gift.create(name: name, price: price, snowman_id: snowman.id )
end

def ready_for_chrimbus
  answer = gets.chomp
  if answer.starts_with?("n")
    puts "That's alright! Plan or no plan, tis the Chrimbus Season! Come back soon!"
    exit
  else
    puts "What a jolly day! Let's get started!"
  end
end

# Menu of options.
def menu_options
  puts "1 - Add friend!"
  puts "2 - Add new gift!"
  puts "3 - Give a gift to friend!"
  puts "4 - Delete a friend."
  puts "5 - Delete a gift."
  puts "6 - Change friend's name."
  puts "7 - Edit gift info."
  puts "8 - See my nice list!"
  puts "9 - See all of my gifts!"
  puts "10 - See which gifts you're giving to a certain friend!"
  puts "11 - I'm over Chrimbus (until next year)!"
end

# Option 8 methods.
def option8
  if Friend.all == []
    puts "Oops! You haven't added any friends yet. Let's do that first!"
  else
    friend_arr = Friend.all.pluck(:name)
    i = 1
    num_arr = friend_arr.map { |friend_name|
      str = "#{i}. #{friend_name}"
      i+=1
      str
    }
    final_arr = num_arr.join(", ")
    puts "Nice list: #{final_arr}!"
    binding.pry
    puts "To go back to your options, press enter."
    gets.chomp
  end
end

# Option 9 methods.
def gift_and_price_arr
  price_arr = Gift.all.pluck(:price)
  gift_arr = Gift.all.pluck(:name)
  combine = gift_arr.zip(price_arr)
  final_arr = combine.map { |pair| "#{pair[0]} for $#{pair[1]}" }
  final_arr.join(", ")
end

def option9
  if Gift.all == []
    puts "Oops! You haven't added any gifts yet. Let's do that first!"
  else
    puts "In your sleigh: #{gift_and_price_arr}!"
    binding.pry
    puts "To go back to your options, press enter."
    gets.chomp
  end
end

def clear_chrimbus
  Friend.destroy_all
  Gift.destroy_all
  Friend_gift.destroy_all
  Snowman.destroy_all
end
