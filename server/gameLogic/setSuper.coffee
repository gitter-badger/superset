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
      derived_cards.push(deriveCard(pair))
    console.log(derived_cards)
    if derived_cards[0].equals(derived_cards[1])
      console.log('VALID SUPER SET')
      Matches.insert({game_id: game_id, type: 'super', number: 4, card_ids: cards, date: new Date().getTime()})
      replaceCards(game_id,cards)
      Statistics.update({game: game_id}, {$inc: {found_supers: 1}})
      return 1
    return 0
