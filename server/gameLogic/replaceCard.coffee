@replaceCard = (game_id,index) ->
  console.log("replace " + index)
  if (cards_left = Gamecards.find({game_id: game_id, status: 'unused'}).count()) == 0
    cycleDeck(game_id)
  R = Math.floor(Math.random() * cards_left)
  gc = Gamecards.find({game_id: game_id, status: 'unused'},{limit: 1, skip: R}).fetch()
  Gamecards.update({game_id: game_id, _id: gc[0]._id, status:'unused'}, {$set: {status: 'playing', order: index}},
    callback = (error,result) ->
      console.log("records affected: " + result)
      if result > 0
        affected = result
        console.log("added: " + affected)
    )
