require_relative '../config/environment'
require_relative './helpers'
require 'pry'

# Welcome message
puts "Ho".colorize(:red) + " Ho".colorize(:green) + " Ho!".colorize(:red) + " Please enter your name:"
name = gets.chomp
snowman = find_or_create_snowman(name)

puts "Merry *almost*" + " Chrimbus".colorize(:red) + ", #{name}! Are you ready to start planning?"
ready_for_chrimbus

# Loop through CLI options.
response = nil
until response == "11"
  menu_options
  response = gets.chomp

# Add a friend to the database
  if response == "1"
    puts "What is your friend".colorize(:green) + "'s name?"
    name = gets.chomp
    create_friend(name, snowman)
    puts "Your friend has been added" + "successfully!".colorize(:green)
    sleep 1

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
      sleep 1

# Grab friend from friend table and assign gift to that friend! <<<<<<< NOT DONE
  elsif response == "3"
    puts "Who would you like to give a gift to?"
    friend_name = gets.chomp
    friend = Friend.find_by(name: friend_name, snowman_id: snowman.id)
    if friend == nil
      puts "This looks like a new friend! Try adding them first before giving a gift."
      sleep 2
      next
    end
    puts "What gift would you like to give #{friend_name}?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name, snowman_id: snowman.id)
    if gift == nil
      puts "That looks like a new gift! Try adding it first before giving it to a friend."
      sleep 3
      next
    end
    friend.friend_gifts.create(gift: gift, snowman: snowman)
    puts "Your gift has been given! Merry Chrimbus!"
    sleep 2

# Delete a friend from the friend table.
  elsif response == "4"
    puts "Who would you like to delete?"
    friend = gets.chomp
    puts "Are you sure you want to delete #{friend}? Y/N"
    confirm = gets.chomp
    confirm.upcase!
    if confirm == "Y"
      Friend.where(name: friend, snowman_id: snowman.id).destroy_all
      puts "#{friend.capitalize!} has been removed from your Chrimbus list!"
      sleep 2
    elsif confirm == "N"
      puts "Your friend is safe! Let's keep Chrimbus-ing!"
      sleep 1
      next
    else
      puts "Mmm, something seems weird... Keep Chrimbus alive? Try again!"
      sleep 2
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
      puts "#{gift.capitalize!} has been removed from the sleigh!"
    elsif confirm == "N"
      puts "Your gift is safe! Let's keep Chrimbus-ing!"
      sleep 1
      next
    else
      puts "Mmm, something seems weird... Keep Chrimbus alive? Try again!"
      sleep 2
      next
    end

# Updating friend info in friend table.
  elsif response == "6"
    puts "Which friend would you like to update?"
    friend_name = gets.chomp
    name = Friend.find_by(name: friend_name, snowman_id: snowman.id)
    # If cannot find friend in friend table...
    if name == nil
      puts "Your friend isn't on your Chrimbus list yet... Try adding them!"
      sleep 1
      next
    end
    # Update name in friend table.
    puts "What would you like their new name to be?"
    new_name = gets.chomp
    name.update(name: new_name, snowman_id: snowman.id)
    puts "Your friend, #{new_name}, has been updated! Isn't Chrimbus the best?"
    sleep 1

# Updating gift info in gift table.
  elsif response == "7"
    puts "Which gift's info would you like to edit?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name, snowman_id: snowman.id)
    if gift == nil
      puts "Mmm, that gift isn't in your sleigh yet... Try adding the gift!"
      sleep 2
      next
    end
    # User chooses between name and price.
    puts "Would you like to edit the 'name' or 'price' of #{gift_name}?"
    response = gets.chomp
    # If user chooses name, change name.
    if response == "name"
      puts "What would you like to change the name of #{gift_name} to?"
      new_name = gets.chomp
      gift.update(name: new_name, snowman_id: snowman.id)
      puts "Your updated name, #{new_name}, has been saved! Chrimbus white-out sleighs."
      sleep 2
    # If user chooses price, change price.
    elsif response == "price"
      current_price = gift.price
      puts "The current price is $#{current_price}. What would you like to change it to?"
      new_price = gets.chomp
      gift.update(price: new_price, snowman_id: snowman.id)
      puts "Your new price, $#{new_price}, has been saved! Chrimbus continues!"
      sleep 2
    else
      puts "Couldn't find what you wanted to change...".colorize(:red) + " Chrimbus is still upon us though! Let's try something else!"
      sleep 2
      next
    end

  # Show a list of all freinds created.
  elsif response == "8"
    if Friend.all.where(snowman: snowman) == []
      puts "Oops! You haven't added any friends yet.".colorize(:red) + " Let's do that first!"
      sleep 1
      next
    else
      friend_arr = Friend.all.where(snowman_id: snowman.id).pluck(:name)
      i = 1
      num_arr = friend_arr.map { |friend_name|
        str = "#{i}." + " #{friend_name.capitalize!}".colorize(:green)
        i+=1
        str
      }
      final_arr = num_arr.join(", ")
      puts "Your Chrimbus pals: #{final_arr}"
      puts "To go back to your options," + " press enter.".colorize(:red)
      gets.chomp
      next
    end


  # Show a list of all the gifts and their prices created.
  elsif response == "9"
      price_arr = Gift.all.where(snowman_id: snowman.id).pluck(:price)
      gift_arr = Gift.all.where(snowman_id: snowman.id).pluck(:name)
      combine = gift_arr.zip(price_arr)
      final_arr = combine.map { |pair| "#{pair[0]}".colorize(:green) + " for $#{pair[1]}" }
      final = final_arr.join(", ")
    if Gift.all.where(snowman: snowman) == []
      puts "Oops! You haven't added any gifts yet.".colorize(:red) + " Let's do that first!"
      sleep 1
    else
      puts "In your sleigh: #{final}!"
      puts "To go back to your options," + " press enter.".colorize(:red)
      gets.chomp
    end
  next

  # Display a list of gifts assigned to all friends of snowman.
  elsif response == "10"
      i=0
      list = snowman.friends.select { |friend| friend.gifts.length > 0 }
      list = list.map { |friend|
          i+=1
          gift_arr = friend.gifts.map { |g| g.name }
          gift_arr = gift_arr.join(", ")
          "#{i}. #{friend.name.capitalize!}'s Chrimbus:" + " #{gift_arr}".colorize(:green) + "!"
        }
        binding.pry
      if list.length == 0
        puts "Oops! It looks like you haven't given any gifts!".colorize(:red) + " Let's do that first."
        sleep 2
      else
        list = list.join(", ")
        puts "#{list}"
        puts "To go back to your options," + " press enter.".colorize(:red)
        gets.chomp
      end

  # Closing the program/ending the CLI.
  elsif response == "11"
    # clear_chrimbus
    exit

  else
    puts "Oops, that's not an option...".colorize(:red) + " Don't worry, Chrimbus will go on! Let's try again and pick a number."
    sleep 2
    next
  end

  puts "What would you like to do?".colorize(:cyan)
end
