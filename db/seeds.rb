# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# As of the creation of this seed file, there are 3 users in the system , with IDs of 3, 4, and 5


events = [
  [2724085], # 6/25 Dead & Co @ Citi Field
  [2724086] # 6/26 Dead & Co @ Citi Field
]

Event.destroy_all

events.each do |a|
  Event.create(jb_event_id: a)
end

y = Event.last.id
x = y - 1

user_events = [
  [3, x],
  [3, y],
  [4, x],
  [4, y],
  [5, x], 
  [5, y]
]

UserEvent.destroy_all

user_events.each do |a, b|
  UserEvent.create(user_id: a, event_id: b, attending: true)
end

group_messages = [
  [x, 3, "Hey, anyone need an extra ticket?"],
  [y, 3, "Anyone need a ride from Long Island?"],
  [x, 4, "This will be my first Dead show! Does anyone want to grab a beer before the show?"],
  [y, 4, "Looking forward to some baseball and some music!"],
  [x, 5, "I can't wait too see John Mayer!"],
  [y, 5, "Night two. Let's do it!"]

]

GroupMessage.destroy_all

group_messages.each do |a, b, c|
  GroupMessage.create(event_id: a, user_id: b, body: c)
end

direct_messages = [
  [x, 3, 4, "Hi Ricardo, how's it going?"],
  [x, 4, 3, "Hey there Jordan. I's going. How about you? Excited for this show?"],
  [x, 3, 4, "Are you kidding me? Of course I am"],
  [x, 4, 3, "Nice, nice. Are you going with anyone? I am going solo, so I was wondering if you were interested in grabbing a drink before the show."],
  [x, 3, 4, "Sure, why not?  Did you have a place in mind?"],

  [x, 3, 5, "Hi Bridget, are you going to Dead and Company?"],
  [x, 5, 3, "You know it, buddy!  It's gonna be great."],

  [y, 3, 4, "Hey man, are you going the second night too?"],
  [y, 4, 3, "Yeah, of course!"],
  
  [y, 3, 5, "Bridgettttttt"],
  [y, 5, 3, "Jordannnnnnnn"]

]

DirectMessage.destroy_all

direct_messages.each do |a, b, c, d|
  DirectMessage.create(event_id: a, sender_id: b, recipient_id: c, body: d)
end