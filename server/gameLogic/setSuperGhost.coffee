Meteor.methods
  setSuperGhost: (game_id = 0,cards) ->
    console.log('processing super ghost set for game: ' + game_id)
    cardcount = Gamecards.find({game_id: game_id, card_mid: {$in: cards}}).count()
    console.log(cardcount)
    if cardcount != 8
      return 'Wrong number of cards'
    pairs = [[cards[0],cards[1]],[cards[2],cards[3]],[cards[4],cards[5]],[cards[6],cards[7]]]
    disjoints = []
    derived_cards = []
    i = 0
    for pair in pairs
      card = deriveCard(pair)
      disjoints[i] = Cards.findOne({number: card[0], color: card[1], shade: card[2], shape: card[3]})
      i++
    pairs = [[disjoints[0]._id,disjoints[1]._id],[disjoints[2]._id,disjoints[3]._id]]
    i = 0
    for pair in pairs
      derived_cards[i] = deriveCard(pair)
      i++
    console.log(derived_cards)
    if derived_cards[0].equals(derived_cards[1])
      console.log('VALID SUPER GHOST SET')
      Matches.insert({game_id: game_id, type: 'superghost', number: 8, card_ids: cards, date: new Date().getTime()})
      replaceCards(game_id,cards)
      Statistics.update({game: game_id}, {$inc: {found_superghosts: 1}})
      return 1
    return 0
