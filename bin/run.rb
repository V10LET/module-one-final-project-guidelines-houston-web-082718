require_relative '../config/environment'
require 'pry'

class Chrimbus

  def initialize
    @snowman_id = nil
  end

# ****************************************************************************
# CLI COMMAND METHODS
# ****************************************************************************

# ----------> Welcome message that captures the username.
  def welcome_message
    puts "Ho".colorize(:red) + " Ho".colorize(:green) + " Ho!".colorize(:red) + " Please enter your name:"
    name = gets.chomp
    snowman = Snowman.find_or_create_by(name: name.capitalize)
    @snowman_id = snowman.id
    puts ""
    puts "Merry *almost*" + " Chrimbus".colorize(:red) + ", #{name.capitalize}! Are you ready to start planning?"
    answer = gets.chomp
    if answer.starts_with?("n")
      puts ""
      puts "That's alright! Plan or no plan, " + "tis always Chrimbus at heart".colorize(:green) + "! Come back soon!"
      puts ""
      chrimus_bush
      exit
    else
      puts ""
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

# ----------> OPTION 1: Creates and adds friend to the database.
  def add_friend_to_db
    puts ""
    puts "What is your " + "friend".colorize(:green) + "'s name?"
    name = gets.chomp
    snowman = Snowman.find_by(id: @snowman_id)
    Friend.create(name: name.capitalize, snowman_id: @snowman_id)
    puts ""
    puts "Your friend, #{name.capitalize}, has been added" + " successfully!".colorize(:green)
    sleep 1
  end

# ----------> OPTION 2: Creates and adds a gift to the database.

  def add_gift_to_db
    puts ""
    puts "What new " + "gift".colorize(:green) + " would you like to give?"
    gift_name = gets.chomp
    if gift_name.end_with?("s")
      puts ""
      puts "How much do #{gift_name} cost?"
    else
      puts ""
      puts "How much does a #{gift_name} cost?"
    end
      price = gets.chomp
      clean_price = price.tr('^0-9\.', '')
      snowman = Snowman.find_by(id: @snowman_id)
      Gift.create(name: gift_name.downcase, price: clean_price, snowman_id: @snowman_id)
    if gift_name.end_with?("s")
      puts ""
      puts "Your #{gift_name} have been" + " saved ".colorize(:green) + "in the sleigh!"
    else
      puts ""
      puts "Your gift, #{gift_name}, has been" + " saved ".colorize(:green) + "in the sleigh!"
    end
      sleep 2
  end

# ----------> OPTION 3: Allows user to give gift to a friend — and pairs friend to gift in database.
  def give_gift_to_friend
    puts ""
    puts "Who would you like to "+"give a gift".colorize(:green) + " to?"
    friend_name = gets.chomp
    friend = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)
    if friend == nil
      puts ""
      puts "This looks like a new friend!".colorize(:red) + " Try adding them first before giving a gift."
      sleep 2
      return
    end
    puts ""
    puts "Which gift".colorize(:green) + " would you like to give #{friend_name.capitalize}?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name.downcase, snowman_id: @snowman_id)
    if gift == nil
      puts ""
      puts "That looks like a new gift!".colorize(:red) + " Try adding it first before giving it to a friend."
      sleep 2
      return
    end
    snowman = Snowman.find_by(id: @snowman_id)
    friend.friend_gifts.create(gift: gift, snowman: snowman)
    puts ""
    puts "Your gift has been given!".colorize(:green) + " Merry Chrimbus!"
    sleep 2
  end

# ----------> OPTION 4: Destroys specified friend row in database.
  def delete_friend
    puts ""
    puts "Who would you like to" + " delete?".colorize(:red)
    friend_name = gets.chomp
    friend = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)

    if friend == nil
      puts ""
    else
      puts ""
      puts "Are you sure you want to delete #{friend_name.capitalize}?" + " Y".colorize(:green) + "/" + "N".colorize(:red)
      confirm = gets.chomp
      confirm.upcase!
    end

    if confirm == "Y"
      Friend.where(name: friend_name.capitalize, snowman_id: @snowman_id).destroy_all
      puts ""
      puts "#{friend_name.capitalize} has been " + "removed".colorize(:red) + " from your Chrimbus list!"
      sleep 2
    elsif confirm == "N"
      puts ""
      puts "Your friend is " + "safe".colorize(:green) + "! Let's keep Chrimbus-ing!"
      sleep 1
    else
      puts "Mmm, something seems weird..." + " Keep Chrimbus alive?".colorize(:red) + " Try something else!"
      sleep 2
      return
    end
  end

# ----------> OPTION 5: Destroys specified gift row in database.
  def delete_gift
    puts ""
    puts "Which gift would you like to " + "delete?".colorize(:red)
    gift_name = gets.chomp
    friend = Gift.find_by(name: gift_name.downcase, snowman_id: @snowman_id)
    if friend == nil
      puts ""
    else
      puts ""
      puts "Are you sure you want to delete the #{gift_name}?" + " Y".colorize(:green) + "/" + "N".colorize(:red)
      confirm = gets.chomp
      confirm.upcase!
    end

    if confirm == "Y"
      snowman = Snowman.find_by(id: @snowman_id)
      gift = snowman.gifts.find_by(name: gift_name.downcase)
      snowman.gifts.delete(gift)
      puts ""
      puts "#{gift_name.capitalize} has been " + "removed".colorize(:red) + " from the sleigh!"
      sleep 1
    elsif confirm == "N"
      puts ""
      puts "Your gift is " + "safe".colorize(:green) + "! Let's keep Chrimbus-ing!"
      sleep 1
    else
      puts "Mmm, something seems weird..." + " Keep Chrimbus alive?".colorize(:red) + " Try something else!"
      sleep 2
      return
    end
  end

# ----------> OPTION 6: User can update friend attributes and they get redefined in database.
  def update_friend_info
    puts ""
    puts "Which friend would you like to" + " update".colorize(:green) + "?"
    friend_name = gets.chomp
    name = Friend.find_by(name: friend_name.capitalize, snowman_id: @snowman_id)
    if name == nil
      puts ""
      puts "Your friend isn't on " + "your Chrimbus list".colorize(:red) + " yet... Try adding them!"
      sleep 2
      return
    end

    puts ""
    puts "What would you like their " + "new name".colorize(:green) + " to be?"
    new_name = gets.chomp
    name.update(name: new_name.capitalize)
    puts ""
    puts "Your friend, #{new_name.capitalize}, has been " + "updated".colorize(:green) + "! Isn't Chrimbus the best?"
    sleep 2
  end

# ----------> OPTION 7: User can update gift attributes and they get redefined in database.
  def update_gift_info
    puts ""
    puts "Which gift".colorize(:green) + "'s info would you like to edit?"
    gift_name = gets.chomp
    gift = Gift.find_by(name: gift_name.downcase, snowman_id: @snowman_id)
    if gift == nil
      puts ""
      puts "Mmm, that " + "gift isn't in your sleigh".colorize(:red) + " yet... Try adding the gift!"
      sleep 2
      return
    end

    puts ""
    puts "Would you like to edit the " + "name".colorize(:red) + " or " + "price".colorize(:green) + " of #{gift_name}?"
    response = gets.chomp

    if response == "name"
      puts ""
      puts "What would you like to " + "change the name".colorize(:green) + " of #{gift_name} to?"
      new_name = gets.chomp
      gift.update(name: new_name.downcase, snowman_id: @snowman_id)
      puts ""
      puts "Your updated name, #{new_name}, has been " + "saved".colorize(:green) + "! Chrimbus white-out sleighs."
      sleep 2

    elsif response == "price"
      current_price = gift.price
      puts ""
      puts "The current price is $#{current_price}. What would you like to " + "change".colorize(:green) + " it to?"
      new_price = gets.chomp
      gift.update(price: new_price, snowman_id: @snowman_id)
      puts ""
      puts "Your new price, $#{new_price}, has been"  + " saved".colorize(:green) + "! Chrimbus continues!"
      sleep 2
    else
      puts ""
      puts "Couldn't find what you wanted to change...".colorize(:red) + " Chrimbus is still upon us though! Let's try something else!"
      sleep 2
      return
    end
  end

# ----------> OPTION 8: Displays a list of friends created by (and thus affiliated with through id) the user.
  def list_of_friends
    puts ""
    snowman = Snowman.find_by(id: @snowman_id)
    if Friend.all.where(snowman: snowman) == []
      puts ""
      puts "Oops! " + "You haven't added any friends yet.".colorize(:red) + " Let's do that first!"
      sleep 2
      return
    else
      friend_arr = Friend.all.where(snowman_id: @snowman_id).pluck(:name)
      i = 1
      num_arr = friend_arr.map { |friend_name|
        str = "#{i}." + " #{friend_name.capitalize}".colorize(:green)
        i+=1
        str
      }
      final_arr = num_arr.join("\n")
      puts ""
      puts "Your Chrimbus pals:"
      line_break
      puts "#{final_arr}"
      line_break
      back_to_options
    end
  end


# ----------> OPTION 9: Displays a list of gifts and their prices created by the user.
  def list_of_gifts
    price_arr = Gift.all.where(snowman_id: @snowman_id).pluck(:price)
    gift_arr = Gift.all.where(snowman_id: @snowman_id).pluck(:name)
    combine = gift_arr.zip(price_arr)
    final_arr = combine.map { |pair| "#{pair[0].capitalize}".colorize(:green) + " for $#{pair[1]}" }
    final_arr = combine.map { |pair| "#{pair[0].capitalize}".colorize(:green) + " for $%0.2f" % [ pair[1] ] }
    final = final_arr.join("\n")
    snowman = Snowman.find_by(id: @snowman_id)
    if Gift.all.where(snowman: snowman) == []
      puts ""
      puts "Oops! " + "You haven't added any gifts yet.".colorize(:red) + " Let's do that first!"
      sleep 2
      return
    else
      puts ""
      puts "In your sleigh:"
      line_break
      puts "#{final}"
      line_break
      back_to_options
    end
  end

# ----------> OPTION 10: Displays all of the user's friends and the gifts assigned to each friend.
  def list_of_friends_and_gifts
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
      puts ""
      puts "Oops! " + "It looks like you haven't given any gifts!".colorize(:red) + " Let's do that first."
      sleep 2
    else
      list = list.join("\n")
      puts ""
      puts "Your gifting list:"
      line_break
      puts "#{list}"
      line_break
      back_to_options
    end
  end

# ----------> OPTION 11: Opt-out for user to exit program.
  def chrimus_bush
    ((1..20).to_a+[6]*4).each{|i|
      puts ('#'*i*2).center(80)};
      puts;
      puts ("Merry".colorize(:red) + " Chrimbus".colorize(:green) + "!".colorize(:cyan)).center(122)
    puts ""
  end


# ****************************************************************************
# HELPER METHODS
# ****************************************************************************


# ----------> This is an alert for if/when a user types in an incorrect number.
  def wrong_number
    puts ""
    puts "Oops, that's not an option...".colorize(:red) + " Don't worry, Chrimbus will go on! Let's try again and pick a number."
    sleep 2
    return
  end

# ----------> This prompts user back to options menu in loop.
def back_to_options
  puts "To go back to your options," + " press enter.".colorize(:red)
  gets.chomp
end

# ----------> This is a stylistic line break.
def line_break
  puts "*".colorize(:red) + "*".colorize(:green) + "*".colorize(:cyan) + "*".colorize(:red) + "*".colorize(:green) + "*".colorize(:cyan) + "*".colorize(:red) + "*".colorize(:green)
end


# ****************************************************************************
# CLI RUN METHOD
# ****************************************************************************


  def run
# ----------> Welcome message with opt-out option.
    welcome_message

# ----------> Loop through CLI options.
    response = nil
    until response == "11"
      menu_options
      response = gets.chomp

# ----------> Add a friend to the database
      if response == "1"
        self.add_friend_to_db

# ----------> Add a new gift to the database
      elsif response == "2"
        self.add_gift_to_db

# ----------> Grab friend from friend table and assign gift to that friend.
      elsif response == "3"
        self.give_gift_to_friend

# ----------> Delete a friend from the friend table.
      elsif response == "4"
        self.delete_friend

# ----------> Delete gift from the gift table.
      elsif response == "5"
        self.delete_gift

# ----------> Updating friend info in friend table.
      elsif response == "6"
        self.update_friend_info

# ----------> Updating gift info in gift table.
      elsif response == "7"
        self.update_gift_info

# ----------> Show a list of all freinds created.
      elsif response == "8"
        self.list_of_friends

# ----------> Show a list of all the gifts and their prices created.
      elsif response == "9"
        self.list_of_gifts

# ----------> Display a list of gifts assigned to all friends of snowman.
      elsif response == "10"
        self.list_of_friends_and_gifts

# ----------> Closing the program/ending the CLI.
      elsif response == "11"
        chrimus_bush
        exit

# ----------> Default option in loop.
      else
        wrong_number
      end

# ----------> End of loop.
      puts ""
      puts "What would you like to do?".colorize(:cyan)
      line_break
    end
  end
end

c = Chrimbus.new
c.run
