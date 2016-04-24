# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# As of the creation of this seed file, there are 3 users in the system , with IDs of 3, 4, and 5

GroupMessage.destroy_all
DirectMessage.destroy_all
UserEvent.destroy_all
Event.destroy_all



events = [
  2724085, # 6/25 Dead & Co @ Citi Field
  2724086 # 6/26 Dead & Co @ Citi Field
]


events.each do |a|
  Event.create(jb_event_id: a)
end

y = Event.last.id
x = y - 1

# in order for this to work, users must exist with id's of 1,2, and 3

user_events = [
  [1, x],
  [1, y],
  [2, x],
  [2, y],
  [3, x], 
  [3, y]
]


user_events.each do |a, b|
  UserEvent.create(user_id: a, event_id: b, attending: true)
end

group_messages = [
  [x, 1, "Hey, anyone need an extra ticket?"],
  [y, 1, "Anyone need a ride from Long Island?"],
  [x, 3, "This will be my first Dead show! Does anyone want to grab a beer before the show?"],
  [y, 3, "Looking forward to some baseball and some music!"],
  [x, 2, "I can't wait too see John Mayer!"],
  [y, 2, "Night two. Let's do it!"]

]


group_messages.each do |a, b, c|
  GroupMessage.create(event_id: a, user_id: b, body: c)
end

direct_messages = [
  [x, 1, 3, "Hi Ricardo, how's it going?"],
  [x, 3, 1, "Hey there Jordan. I's going. How about you? Excited for this show?"],
  [x, 1, 3, "Are you kidding me? Of course I am"],
  [x, 3, 1, "Nice, nice. Are you going with anyone? I am going solo, so I was wondering if you were interested in grabbing a drink before the show."],
  [x, 1, 3, "Sure, why not?  Did you have a place in mind?"],

  [x, 1, 2, "Hi Bridget, are you going to Dead and Company?"],
  [x, 2, 1, "You know it, buddy!  It's gonna be great."],

  [y, 1, 3, "Hey man, are you going the second night too?"],
  [y, 3, 1, "Yeah, of course!"],
  
  [y, 1, 2, "Bridgettttttt"],
  [y, 2, 1, "Jordannnnnnnn"]

]

direct_messages.each do |a, b, c, d|
  DirectMessage.create(event_id: a, sender_id: b, recipient_id: c, body: d)
end