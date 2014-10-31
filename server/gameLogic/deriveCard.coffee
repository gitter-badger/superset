@deriveCard = (pair) ->
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
  return [N3,C3,SD3,SP3]
