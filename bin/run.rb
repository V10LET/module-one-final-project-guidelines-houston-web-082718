require_relative '../config/environment'
require_relative './helpers'
require 'pry'

class Cli

  def initialize
    @snowman_id = nil
  end

# ----------> Welcome message that captures the username.
  def welcome_message
    puts "Ho".colorize(:red) + " Ho".colorize(:green) + " Ho!".colorize(:red) + " Please enter your name:"
    name = gets.chomp
    snowman = Snowman.find_or_create_by(name: name.capitalize)
    @snowman_id = snowman.id

    puts "Merry *almost*" + " Chrimbus".colorize(:red) + ", #{name.capitalize}! Are you ready to start planning?"
    answer = gets.chomp
    if answer.starts_with?("n")
      puts ""
      puts "That's alright! Plan or no plan, " + "tis always Chrimbus at heart".colorize(:green) + "! Come back soon!"
      puts ""
      chrimus_bush
      exit
    else
      puts " "
      puts "What a magical day! Let's get started...".colorize(:cyan)
      line_break
    end
  end

# ----------> Menu options displayed in loop.
  def menu_options
    puts "1 -" + " Add friend!".colorize(:green)
    puts "2 -" + " Add new gift!"
    puts "3 -" + " Give a gift to friend!".colorize(:green)
    puts "4 -" + " Delete a friend."
    puts "5 -" + " Delete a gift.".colorize(:green)
    puts "6 -" + " Change a friend's name."
    puts "7 -" + " Edit a gift's info.".colorize(:green)
    puts "8 -" + " See all my friends!"
    puts "9 -" + " See all my gifts!".colorize(:green)
    puts "10 -" + " See what I'm giving each friend!"
    puts "11 -" + " Retire from Chrimbus...".colorize(:red)
  end

# ----------> Creates and adds friend to the database.
  def cmd_add_friend_to_db
    puts ""
    puts "What is your " + "friend".colorize(:green) + "'s name?"
    name = gets.chomp
    snowman = Snowman.find_by(id: @snowman_id)
    create_friend(name.capitalize, snowman)
    puts "Your friend, #{name.capitalize}, has been added" + " successfully!".colorize(:green)
    sleep 1
  end

  def run
# ----------> Loop through CLI options.
    welcome_message

# ----------> Loop through CLI options.
    response = nil
    until response == "11"
      menu_options
      response = gets.chomp

# ----------> Add a friend to the database
      if response == "1"
        self.cmd_add_friend_to_db

    # Add a new gift to the database
      elsif response == "2"
        puts " "
        puts "What new " + "gift".colorize(:green) + " would you like to give?"
        gift_name = gets.chomp
        if gift_name.end_with?("s")
          puts ""
          puts "How much do #{gift_name} cost?"
        else
          puts ""
          puts "How much does #{gift_name} cost?"
        end
          price = gets.chomp
          clean_price = sanitize_price(price)
          snowman = Snowman.find_by(id: @snowman_id)
          create_gift(gift_name.downcase, clean_price, snowman)
        if gift_name.end_with?("s")
          puts ""
          puts "Your gift, #{gift_name}, have been" + " saved ".colorize(:green) + "in the sleigh!"
        else
          puts ""
          puts "Your gift, #{gift_name}, has been" + " saved ".colorize(:green) + "in the sleigh!"
        end
          sleep 2

    # Grab friend from friend table and assign gift to that friend!
      elsif response == "3"
        puts ""
        puts "Who would you like to "+"give a gift".colorize(:green) + " to?"
        friend_name = gets.chomp
        friend = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)
        if friend == nil
          puts "This looks like a new friend!".colorize(:red) + " Try adding them first before giving a gift."
          sleep 2
          next
        end
        puts ""
        puts "Which gift".colorize(:green) + " would you like to give #{friend_name.capitalize}?"
        gift_name = gets.chomp
        gift = Gift.find_by(name: gift_name.downcase, snowman_id: @snowman_id)
        if gift == nil
          puts ""
          puts "That looks like a new gift!".colorize(:red) + " Try adding it first before giving it to a friend."
          sleep 2
          next
        end
        snowman = Snowman.find_by(id: @snowman_id)
        friend.friend_gifts.create(gift: gift, snowman: snowman)
        puts ""
        puts "Your gift has been given!".colorize(:green) + " Merry Chrimbus!"
        sleep 2

    # Delete a friend from the friend table.
      elsif response == "4"
        puts "Who would you like to" + " delete?".colorize(:red)
        friend_name = gets.chomp
        friend = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)
        if friend == nil
          puts ""
          puts "Your " + "friend doesn't exist".colorize(:red) + " on your Chrimbus list yet... Try adding them!"
        else
          puts ""
          puts "Are you sure you want to delete #{friend_name.capitalize}?" + " Y".colorize(:green) + "/" + "N".colorize(:red)
          confirm = gets.chomp
          confirm.upcase!
        end
        if confirm == "Y"
          Friend.where(name: friend_name.capitalize, snowman_id: @snowman_id).destroy_all
          puts "#{friend_name.capitalize} has been " + "removed".colorize(:red) + " from your Chrimbus list!"
          sleep 2
        elsif confirm == "N"
          puts "Your friend is " + "safe".colorize(:green) + "! Let's keep Chrimbus-ing!"
          sleep 1
        else
          puts "Mmm, something seems weird..." + " Keep Chrimbus alive?".colorize(:red) + " Try again!"
          sleep 2
          next
        end

    # Delete gift from the gift table.
      elsif response == "5"
        puts "Which gift would you like to " + "delete?".colorize(:red)
        gift_name = gets.chomp
        puts "Are you sure you want to delete the #{gift_name}?" + " Y".colorize(:green) + "/" + "N".colorize(:red)
        confirm = gets.chomp
        confirm.upcase!
        if confirm == "Y"
          snowman = Snowman.find_by(id: @snowman_id)
          gift = snowman.gifts.find_by(name: gift_name.downcase)
          snowman.gifts.delete(gift)
          # Gift.where(name: gift_name.downcase, snowman_id: snowman.id).destroy_all
          puts "#{gift_name.capitalize} has been " + "removed".colorize(:red) + " from the sleigh!"
          sleep 1
        elsif confirm == "N"
          puts "Your gift is " + "safe".colorize(:green) + "! Let's keep Chrimbus-ing!"
          sleep 1
        else
          puts "Mmm, something seems weird..." + " Keep Chrimbus alive?".colorize(:red) + " Try again!"
          sleep 2
          next
        end

    # Updating friend info in friend table.
      elsif response == "6"
        puts ""
        puts "Which friend would you like to" + " update".colorize(:green) + "?"
        friend_name = gets.chomp
        name = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)
        # If cannot find friend in friend table...
        if name == nil
          puts "Your friend isn't on " + "your Chrimbus list".colorize(:red) + " yet... Try adding them!"
          sleep 1
          next
        end
        # Update name in friend table.
        puts ""
        puts "What would you like their " + "new name".colorize(:green) + " to be?"
        new_name = gets.chomp
        name.update(name: new_name.capitalize)
        puts "Your friend, #{new_name.capitalize}, has been " + "updated".colorize(:green) + "! Isn't Chrimbus the best?"
        sleep 2

    # Updating gift info in gift table.
      elsif response == "7"
        puts ""
        puts "Which gift".colorize(:green) + "'s info would you like to edit?"
        gift_name = gets.chomp
        gift = Gift.find_by(name: gift_name.downcase, snowman_id: @snowman_id)
        if gift == nil
          puts "Mmm, that " + "gift isn't in your sleigh".colorize(:red) + " yet... Try adding the gift!"
          sleep 2
          next
        end
        # User chooses between name and price.
        puts "Would you like to edit the " + "name".colorize(:red) + " or " + "price".colorize(:green) + " of #{gift_name.capitalize}?"
        response = gets.chomp
        # If user chooses name, change name.
        if response == "name"
          puts "What would you like to " + "change the name".colorize(:green) + " of #{gift_name.capitalize} to?"
          new_name = gets.chomp
          gift.update(name: new_name.downcase, snowman_id: @snowman_id)
          puts ""
          puts "Your updated name, #{new_name}, has been " + "saved".colorize(:green) + "! Chrimbus white-out sleighs."
          sleep 2
        # If user chooses price, change price.
        elsif response == "price"
          current_price = gift.price
          puts "The current price is $#{current_price}. What would you like to " + "change".colorize(:green) + " it to?"
          new_price = gets.chomp
          gift.update(price: new_price, snowman_id: @snowman_id)
          puts "Your new price, $#{new_price}, has been"  + " saved".colorize(:green) + "! Chrimbus continues!"
          sleep 2
        else
          puts "Couldn't find what you wanted to change...".colorize(:red) + " Chrimbus is still upon us though! Let's try something else!"
          sleep 2
          next
        end

      # Show a list of all freinds created.
      elsif response == "8"
        puts " "
        snowman = Snowman.find_by(id: @snowman_id)
        if Friend.all.where(snowman: snowman) == []
          puts "Oops! " + "You haven't added any friends yet.".colorize(:red) + " Let's do that first!"
          sleep 2
          next
        else
          friend_arr = Friend.all.where(snowman_id: @snowman_id).pluck(:name)
          i = 1
          num_arr = friend_arr.map { |friend_name|
            str = "#{i}." + " #{friend_name.capitalize}".colorize(:green)
            i+=1
            str
          }
          final_arr = num_arr.join("\n")
          puts " "
          puts "Your Chrimbus pals:"
          line_break
          puts "#{final_arr}"
          line_break
          puts "To go back to your options," + " press enter.".colorize(:red)
          gets.chomp
        end


      # Show a list of all the gifts and their prices created.
      elsif response == "9"
          price_arr = Gift.all.where(snowman_id: @snowman_id).pluck(:price)
          gift_arr = Gift.all.where(snowman_id: @snowman_id).pluck(:name)
          combine = gift_arr.zip(price_arr)
          final_arr = combine.map { |pair| "#{pair[0].capitalize}".colorize(:green) + " for $#{pair[1]}" }
          final_arr = combine.map { |pair| "#{pair[0].capitalize}".colorize(:green) + " for $%0.2f" % [ pair[1] ] }
          final = final_arr.join("\n")
        if Gift.all.where(snowman: snowman) == []
          puts ""
          puts "Oops! " + "You haven't added any gifts yet.".colorize(:red) + " Let's do that first!"
          next
          sleep 2
        else
          puts " "
          puts "In your sleigh:"
          line_break
          puts "#{final}"
          line_break
          puts "To go back to your options," + " press enter.".colorize(:red)
          gets.chomp
        end

      # Display a list of gifts assigned to all friends of snowman.
      elsif response == "10"
          i=0
          snowman = Snowman.find_by(id: @snowman_id)
          list = snowman.friends.select { |friend| friend.gifts.length > 0 }
          list = list.map { |friend|
              i+=1
              gift_arr = friend.gifts.map { |g| g.name }
              gift_arr = gift_arr.join(", ")
              "#{i}.".colorize(:cyan) + " #{friend.name.capitalize} is getting:" + " #{gift_arr}".colorize(:green) + "!"
            }
          if list.length == 0
            puts "Oops! " + "It looks like you haven't given any gifts!".colorize(:red) + " Let's do that first."
            sleep 2
          else
            list = list.join("\n")
            puts ""
            puts "Your gifting list:"
            line_break
            puts "#{list}"
            line_break
            puts "To go back to your options," + " press enter.".colorize(:red)
            gets.chomp
          end

      # Closing the program/ending the CLI.
      elsif response == "11"
        chrimus_bush
        exit

      else
        puts "Oops, that's not an option...".colorize(:red) + " Don't worry, Chrimbus will go on! Let's try again and pick a number."
        sleep 2
        next
      end

      puts " "
      puts "What would you like to do?".colorize(:cyan)
      line_break

    end
  end
end

cli = Cli.new
cli.run

# binding.pry
# Welcome message
