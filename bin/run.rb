require_relative '../config/environment'
require_relative './helpers'
require 'pry'

# Welcome message
puts "Ho Ho Ho! Please enter your name:"
name = gets.chomp

snowman = create_snowman(name)

puts "Merry *almost* Chrimbus, #{name}! Are you ready to start planning?"
ready_for_chrimbus

# Loop through CLI options.
response = nil
until response == "11"
  menu_options
  response = gets.chomp

# Add a friend to the database
  if response == "1"
    puts "What is your friend's name?"
    name = gets.chomp
    create_friend(name, snowman)
    puts "Your friend has been added to the nice list!"

# Add a new gift to the database
  elsif response == "2"
    puts "What new gift would you like to give?"
    gift = gets.chomp
    if gift.end_with?("s")
      puts "How much do #{gift} cost?"
    else
      puts "How much does #{gift} cost?"
    end
      price = gets.chomp
      clean_price = sanitize_price(price)
      create_gift(gift, clean_price, snowman)
      puts "You gift has been saved in the sleigh!"

# Grab friend from friend table and assign gift to that friend! <<<<<<< NOT DONE
  elsif response == "3"
    puts "Who would you like to give a gift to?"
    friend_name = gets.chomp
    friend = Friend.find_by(name: friend_name)
    if friend == nil
      puts "This looks like a new friend! Try adding them first before giving a gift."
      next
    end
    puts "What gift would you like to give #{friend_name}?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name)
    if gift == nil
      puts "That looks like a new gift! Try adding it first before giving it to a friend."
      next
    end
    puts "Your gift has been given! Merry Chrimbus!"
    Friend_gift.create(friend_id: friend.id, gift_id: gift.id)

# Delete a friend from the friend table.
  elsif response == "4"
    puts "Who would you like to delete?"
    friend = gets.chomp
    puts "Are you sure you want to delete #{friend}? Y/N"
    confirm = gets.chomp
    confirm.upcase!
    if confirm == "Y"
      Friend.where(name: friend, snowman_id: snowman.id).destroy_all
      puts "#{friend} has been removed from your Chrimbus list!"
    elsif confirm == "N"
      puts "Your friend is safe! Let's keep Chrimbus-ing!"
      next
    else
      puts "Mmm, something seems weird... Keep Chrimbus alive? Try again!"
      next
    end

# Delete gift from the gift table.
  elsif response == "5"
    puts "Which gift would you like to delete?"
    gift = gets.chomp
    puts "Are you sure you want to delete the #{gift}? Y/N"
    confirm = gets.chomp
    confirm.upcase!
    if confirm == "Y"
      Gift.where(name: gift, snowman_id: snowman.id).destroy_all
      puts "#{gift} has been removed from the sleigh!"
    elsif confirm == "N"
      puts "Your gift is safe! Let's keep Chrimbus-ing!"
      next
    else
      puts "Mmm, something seems weird... Keep Chrimbus alive? Try again!"
      next
    end

# Updating friend info in friend table.
  elsif response == "6"
    puts "Which friend would you like to update?"
    friend_name = gets.chomp
    name = Friend.find_by(name: friend_name)
    # If cannot find friend in friend table...
    if name == nil
      puts "Your friend isn't on your Chrimbus list yet... Try adding them!"
      next
    end
    # Update name in friend table.
    puts "What would you like their new name to be?"
    new_name = gets.chomp
    name.update(name: new_name)
    puts "Your friend, #{new_name}, has been updated! Isn't Chrimbus the best?"

# Updating gift info in gift table.
  elsif response == "7"
    puts "Which gift's info would you like to edit?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name)
    if gift == nil
      puts "Mmm, that gift isn't in your sleigh yet... Try adding the gift!"
      next
    end
    # User chooses between name and price.
    puts "Would you like to edit the 'name' or 'price' of #{gift_name}?"
    response = gets.chomp
    # If user chooses name, change name.
    if response == "name"
      puts "What would you like to change the name of #{gift_name} to?"
      new_name = gets.chomp
      gift.update(name: new_name)
      puts "Your updated name, #{new_name}, has been saved! Chrimbus white-out sleighs."
    # If user chooses price, change price.
    elsif response == "price"
      current_price = gift.price
      puts "The current price is $#{current_price}. What would you like to change it to?"
      new_price = gets.chomp
      gift.update(price: new_price)
      puts "Your new price, $#{new_price}, has been saved! Chrimbus continues!"
    else
      puts "Couldn't find what you wanted to change... Chrimbus is still upon us though! Let's try something else!"
      next
    end

  # Show a list of all freinds created.
  elsif response == "8"
  option8
  next

  # Show a list of all the gifts and their prices created.
  elsif response == "9"
  option9
  next

  # Display a list of gifts assigned to all friends of snowman.
  elsif response == "10"


  # Closing the program/ending the CLI.
  elsif response == "11"
    # clear_chrimbus
    exit

  else
    puts "Oops, that's not an option... Don't worry, Chrimbus will go on! Let's try again and pick a number."
    next
  end

  puts "What would you like to do?"
end
