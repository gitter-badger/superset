@removeGaps = (game_id) ->
  max_order = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: -1}, limit: 1}).fetch()
  console.log(max_order[0].order)
  while max_order[0].order > 12
    cards = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: 1}}).fetch()
    i = 0
    for card in cards
      i++
      if card.order > i
        Gamecards.update({game_id: game_id, _id: max_order[0]._id}, {$set: {order: i}},
          callback = (error,result) ->
            console.log("moved " + max_order[0].order + " to " + i)
        )
        break
    max_order = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: -1}, limit: 1}).fetch()
