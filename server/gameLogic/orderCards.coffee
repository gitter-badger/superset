@orderCards = (game_id) ->
  console.log(game_id)
  cards = Gamecards.find({game_id: game_id, status: 'playing'}).fetch()
  i = 1
  for card in cards
    console.log(card)
    Gamecards.update({game_id: game_id, _id: card._id}, {$set: {order: i}})
    i++
