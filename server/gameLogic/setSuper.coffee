Meteor.methods
  setSuper: (game_id = 0,cards) ->
    console.log('processing super set for game: ' + game_id)
    cardcount = Gamecards.find({game_id: game_id, card_mid: {$in: cards}}).count()
    console.log(cardcount)
    if cardcount != 4
      return 'Wrong number of cards'
    pairs = [[cards[0],cards[1]],[cards[2],cards[3]]]
    derived_cards = []
    for pair in pairs
      c = Cards.find({_id: {$in: pair}}).fetch()
      N = 0
      C = 0
      SD = 0
      SP = 0
      for card in c
        N = N + card.number
        C = C + card.color
        SD = SD + card.shade
        SP = SP + card.shape
      N3 = card_lookup[N]
      C3 = card_lookup[C]
      SD3 = card_lookup[SD]
      SP3 = card_lookup[SP]
      derived_cards.push([N3,C3,SD3,SP3])
    console.log(derived_cards)
    if derived_cards[0].equals(derived_cards[1])
      console.log('VALID SUPER SET')
      Matches.insert({game_id: game_id, type: 'super', number: 4, card_ids: cards, date: new Date().getTime()})
      replaceCards(game_id,cards)
      Statistics.update({game: game_id}, {$inc: {found_super: 1}})
      return 1
    return 0

    #   for card in cards
    #     n++
    #     in_play = Gamecards.find({game_id: game_id, status: 'playing'}).count()
    #     matched_card = Gamecards.findOne({game_id: game_id, card_mid: card})
    #     matched_card = matched_card.order
    #     console.log("replacing: " + matched_card)
    #     Gamecards.update({game_id: game_id, card_mid: card, status: 'playing'}, {$set: {status: 'matched'}, $unset: {order: ""}}, {multi: true})
    #     if matched_card < 13 && in_play - n < 13
    #       replaceCard(game_id,matched_card)
    #   removeGaps(game_id)
    #
    #   if iso == 0
    #     Statistics.update({game: game_id}, {$inc: {found_ghosts: 1}})
    #     result = 1
    #   else
    #     Statistics.update({game: game}, {$inc: {found_isoghosts: 1}})
    #     result = 1
    # else
    #   result = 0
    #
    # return result
