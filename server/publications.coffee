Meteor.publish('cards', () ->
  return Cards.find()
)
Meteor.publish('gamecards', () ->
  return Gamecards.find({game_id: 0, status: 'playing'})
)
Meteor.publish('games', () ->
  return Games.find()
)
Meteor.publish('statistics', () ->
  return Statistics.find()
)
Meteor.publish('matches', () ->
  return Matches.find({game_id: 0}, {sort: {date: -1}, limit: 15})
)
