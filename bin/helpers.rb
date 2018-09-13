def find_or_create_snowman(name)
  Snowman.find_or_create_by(name: name)
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
    puts "What a magical day! Let's get started!"
  end
end

# Menu of options.
def menu_options
  puts "1 - Add friend!"
  puts "2 - Add new gift!"
  puts "3 - Give a gift to friend!"
  puts "4 - Delete a friend."
  puts "5 - Delete a gift."
  puts "6 - Change a friend's name."
  puts "7 - Edit a gift's info."
  puts "8 - See all my friends!"
  puts "9 - See all my gifts!"
  puts "10 - See what I'm giving each friend!"
  puts "11 - Retire from Chrimbus..."
end

# Option 8 methods.
def option8
end

# Option 9 methods.

def option9
end
