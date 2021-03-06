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

        Matches.insert({game_id: game_id, type: 'normal', number: 3, card_ids: cards, date: new Date().getTime()})
        replaceCards(game_id,cards)
        Statistics.update({game: game_id}, {$inc: {found_sets: 1}})
    else
      message = 'Wrong number of cards'
    return message
