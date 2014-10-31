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

@replaceCards = (game_id,cards) ->
  n = 0
  for card in cards
    console.log(card)
    in_play = Gamecards.find({game_id: game_id, status: 'playing'}).count()
    matched_card = Gamecards.findOne({game_id: game_id, card_mid: card})
    matched_card = matched_card.order
    console.log("replacing: " + matched_card + " in_play: " + in_play + " n ")
    Gamecards.update({game_id: game_id, card_mid: card, status: 'playing'}, {$set: {status: 'matched'}, $unset: {order: ""}}, {multi: true})
    if matched_card < 13 && in_play < 13
      replaceCard(game_id,matched_card)
  removeGaps(game_id)
