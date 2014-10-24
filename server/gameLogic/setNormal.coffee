Meteor.methods
  set: (game_id = 0,cards) ->
    c = Cards.find({_id: {$in: cards}}).fetch()
    gc = Gamecards.find({game_id: game, card_mid: {$in: cards}, status: 'playing'}).fetch()
    console.log(cards)
    console.log(c)
    if cards.length == 3 && c.length == 3 && gc.length == 3
      N = 0
      C = 0
      SD = 0
      SP = 0
      (N += card.number; C += card.color; SD += card.shade; SP += card.shape) for card in c
      if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0))
        console.log("VALID SET")
        console.log(cards)

        for card in cards
          in_play = Gamecards.find({game_id: game_id, status: 'playing'}).count()
          matched_card = Gamecards.findOne({game_id: game_id, card_mid: card})
          matched_card = matched_card.order
          Gamecards.update({game_id: game_id, card_mid: card, status: 'playing'}, {$set: {status: 'matched'}, $unset: {order: ""}}, {multi: true})
          console.log("replacing: " + matched_card)
          if matched_card < 13 && in_play < 13
            replaceCard(game_id,matched_card)
        Statistics.update({game: game_id}, {$inc: {found_sets: 1}})
        removeGaps(game_id)
    else
      message = 'Wrong number of cards'
    return message
