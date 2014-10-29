

Session.setDefault("counter", 0)
Session.setDefault("interface-type", "card")
Session.setDefault("game", 'normal')
Session.setDefault("isometric", "false")
Session.setDefault("selection-limit", 3)
Session.setDefault("dark","false")
sec = -1

@cdelay = 600
@game = 0

pad = (val) ->
  return if val > 9 then val else "0" + val

@gameTypes = ['normal','super','ghost','isoghost','superghost']

gameButton = (type) ->
  for gameType in gameTypes
    if type == gameType
      Session.set("game-" + gameType,"true")
      $('.game-' + gameType).addClass('pressed')
    else
      Session.set("game-" + gameType,"false")
      $('.game-' + gameType).removeClass('pressed')

procScore = (type) ->
  localStorage.setItem("sets_" + type, parseInt(localStorage.getItem("sets_" + type)) + 1);
  $('.sets_' + type).html(localStorage.getItem("sets_" + type))
  $('.sets_' + type).addClass('scored')
  Meteor.setTimeout((-> $('.sets_' + type).removeClass('scored')), cdelay)
  localStorage.setItem("b_sets_" + type, parseInt(localStorage.getItem("dt_sets_" + type)) + 1);
  console.log('score ' + localStorage.getItem("dt_sets_" + type))
  $('.sets_' + type + '_elapsed').html("0")
  sec = -1

$( document).ready () ->
  if !localStorage.getItem("sets_normal")
    localStorage.setItem("sets_normal",0)
  $('.sets_normal').html(localStorage.getItem("sets_normal"))

  if !localStorage.getItem("sets_ghost")
    localStorage.setItem("sets_ghost",0)
  $('.sets_ghost').html(localStorage.getItem("sets_ghost"))

  if !localStorage.getItem("sets_isoghost")
    localStorage.setItem("sets_isoghost",0)
  $('.sets_isoghost').html(localStorage.getItem("sets_isoghost"))


  setInterval ->
    $("#te_s").html(pad(++sec % 60))
    $("#te_m").html(pad(parseInt(sec / 60, 10) % 60))
    $("#te_h").html(pad(parseInt(sec / 3600, 10)))
  ,1000
  $('.sets_normal_elapsed').html(localStorage.getItem("dt_sets_normal") - localStorage.getItem("b_sets_normal"))
  $('.sets_ghost_elapsed').html(localStorage.getItem("dt_sets_ghost") - localStorage.getItem("b_sets_ghost"))
  $('.sets_isoghost_elapsed').html(localStorage.getItem("dt_sets_isoghost") - localStorage.getItem("b_sets_isoghost"))

  Session.set("game-normal","true")
  $('.game-normal').addClass('pressed')
  for gameType in gameTypes
    if gameType != 'normal'
      Session.set("game-" + gameType,"false")
      $('.game-' + gameType).removeClass('pressed')





@shapes = ['diamond', 'oval', 'squiggle']
@colors = ['green', 'purple', 'red']
@shades = ['empty', 'shaded', 'solid']
@numbers = ['one', 'two', 'three']

@keybindings = ['81','87','69','82']
@keybindings = ['65','83','68','70']
@keybindings = ['90','88','67','86']

@key = []
@key[81] = 0
@key[87] = 1
@key[69] = 2
@key[82] = 3
@key[65] = 4
@key[83] = 5
@key[68] = 6
@key[70] = 7
@key[90] = 8
@key[88] = 9
@key[67] = 10
@key[86] = 11

set = []



Meteor.startup ->
  Meteor.subscribe('cards')
  Meteor.subscribe('gamecards')
  Meteor.subscribe('games')
  Meteor.subscribe('statistics')
  Meteor.subscribe('matches')



Template.globalGame.events
  'click .check': () ->
    Meteor.call 'check_sets', game, (error, result) ->
      if error
        console.log(error)
      else
        $('.messages').append('<div class="chk">'+result+'</div>')
        Meteor.setTimeout((-> $('.chk').remove()), 1000)
  'click .display': ->
    if Session.get("interface-type") == "card"
      $('.button.display').addClass('pressed')
      Session.set("interface-type","textcard")
    else
      $('.button.display').removeClass('pressed')
      Session.set("interface-type","card")
  'click .game-normal': ->
    gameButton('normal')
    Session.set("selection-limit", 3)
  'click .game-super': ->
    gameButton('super')
    Session.set("selection-limit", 4)
  'click .game-ghost': ->
    gameButton('ghost')
    Session.set("selection-limit", 6)
  'click .game-isoghost': ->
    gameButton('isoghost')
    Session.set("selection-limit", 6)
  'click .game-superghost': ->
    gameButton('superghost')
    Session.set("selection-limit", 8)
  'click .vision': ->
      if Session.get("dark") == "false"
        $('body').addClass('dark')
        $('.button').not('.vision').addClass('dark')
        $('.vision').removeClass('dark').addClass('light')
        Session.set("dark","true")
      else
        $('body').removeClass('dark')
        $('.button').removeClass('dark')
        $('.vision').removeClass('light').addClass('dark')
        Session.set("dark","false")

doSelect = (item) ->
  if typeof(item.id) != 'undefined'
    item = $('#' + item.id)
  if ($(item).hasClass('selected'))
    $(item).removeClass('selected')
    i = 0
    match = 0
    for card in set
      if (card.id == item.id)
        match = i
      i++
    t = set.splice(match,1)
  else
    if ($('.card.selected').length < Session.get("selection-limit"))
      $(item).addClass('selected')
      set.push(item)

  console.log('selected cards ' + $('.card.selected').length)

  if Session.get("game-normal") == "true"
    if ($('.card.selected').length == 3)
      N = 0
      C = 0
      SD = 0
      SP = 0
      (N = N + card.data("number"); C = C + card.data("color"); SD = SD + card.data("shade"); SP = SP + card.data("shape")) for card in set
      delay = 3500
      delay_increment = 750
      console.log("N = " + N)
      if (N % 3 == 0)
        v_number = true
      else
        v_number = false
        $('.messages').append('<div class="n">Number does not qualify.</div>')
        Meteor.setTimeout((-> $('.n').remove()), delay)
        delay += delay_increment
      if (C % 3 == 0)
        v_color = true
      else
        v_color = false
        $('.messages').append('<div class="c">Color does not qualify.</div>')
        Meteor.setTimeout((-> $('.c').remove()), delay)
        delay += delay_increment
      if (SD % 3 == 0)
        v_shade = true
      else
        v_shade = false
        $('.messages').append('<div class="sd">Shade does not qualify.</div>')
        Meteor.setTimeout((-> $('.sd').remove()), delay)
        delay += delay_increment
      if (SP % 3 == 0)
        v_shape = true
      else
        v_shape = false
        $('.messages').append('<div class="sp">Shape does not qualify.</div>')
        Meteor.setTimeout((-> $('.sp').remove()), delay)
        delay += delay_increment
      if (v_number && v_color && v_shade && v_shape)
        procScore('normal')
        $('.messages').append('<div class="v">Valid Set!</div>')
        Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        setargs = []
        setargs.push card.prop("id") for card in set
        console.log(setargs)
        Meteor.call('set', game, setargs)
        Meteor.setTimeout((-> $('.selected').removeClass('selected')))
        set = []
      else
        set = []
        Meteor.setTimeout((-> $('.selected').removeClass('selected')), 250)
  else if ((Session.get("game-ghost") == "true") || (Session.get("game-isoghost") == "true"))
    if ($('.card.selected').length == 6)
      setargs = []
      setargs.push card.prop("id") for card in set
      if Session.get("game-isoghost") == "true"
        iso = 1
      else
        iso = 0
      Meteor.call 'setGhost', game, setargs, iso, (error, result) ->
        if error
          console.log(error)
        else
          if result == 1
            if iso == 0
              message = 'Valid Ghost Set!'
              procScore('ghost')

            else
              message = 'Valid Isometric Ghost Set!'
              procScore('isoghost')
          else
            if iso == 0
              message = 'Not a valid Ghost Set'
            else
              message = 'Not a valid Isometric Ghost Set (selection order matters)'
          $('.messages').append('<div class="chk">'+message+'</div>')
          Meteor.setTimeout((-> $('.chk').remove()), 1750)
      Meteor.setTimeout((-> $('.selected').removeClass('selected')))
      set = []
  else if Session.get("game-super") == "true"
    if ($('.card.selected').length == 4)
      console.log('super proc')
      setargs = []
      setargs.push card.prop("id") for card in set
      console.log(setargs)
      Meteor.call 'setSuper', game, setargs, (error, result) ->
        if error
          console.log(error)
        else
          if result == 1
            message = 'Valid Super Set!'
            procScore('super')
          else
            message = 'Not a valid Super Set (order matters)'
          $('.messages').append('<div class="chk">'+message+'</div>')
          Meteor.setTimeout((-> $('.chk').remove()), 1750)
      Meteor.setTimeout((-> $('.selected').removeClass('selected')))
      set = []


Template.globalGame.events
  'click .card': (e, template) ->
    e.preventDefault();
    doSelect(e.target)

window.onkeyup = (e) ->
  if typeof(key[e.which]) != 'undefined'
    console.log($('.card').eq(key[e.which]).prop("id"))
    doSelect($('.card').eq(key[e.which]))

Template.nav.helpers
  statistics: ->
    s = Statistics.findOne({game: game})
    if s && !Session.get("score_init")
      console.log("run once")
      console.log(localStorage.getItem("b_sets_normal"))
      if !parseInt(localStorage.getItem("b_sets_normal"))
        localStorage.setItem("b_sets_normal", s.found_sets)
      if !parseInt(localStorage.getItem("b_sets_ghost"))
        localStorage.setItem("b_sets_ghost", s.found_ghosts)
      if !parseInt(localStorage.getItem("b_sets_isoghost"))
        localStorage.setItem("b_sets_isoghost", s.found_isoghosts)
      localStorage.setItem('dt_sets_normal',s.found_sets)
      localStorage.setItem('dt_sets_ghost',s.found_ghosts)
      localStorage.setItem('dt_sets_isoghost',s.found_isoghosts)
      Session.set("score_init",1)
    return s
  buttonstate: (name,value) ->
    if Session.get(name) == 'true'
      return 'pressed'

query = Statistics.find({game: game})
handle = query.observeChanges(
  changed: (id, record)->
    if record.found_sets
      if record.found_sets > localStorage.getItem("b_sets_normal")
        $('.sets_normal_elapsed').addClass('scored')
        Meteor.setTimeout((-> $('.sets_normal_elapsed').removeClass('scored')), cdelay)
      $('.sets_normal_elapsed').html(record.found_sets - localStorage.getItem("b_sets_normal"))
      console.log(record.found_sets + ' - ' + localStorage.getItem("b_sets_normal"))
      localStorage.setItem("dt_sets_normal",record.found_sets)

    if record.found_ghosts
      if record.found_ghosts > localStorage.getItem("b_sets_ghost")
        $('.sets_ghost_elapsed').addClass('scored')
        Meteor.setTimeout((-> $('.sets_ghost_elapsed').removeClass('scored')), cdelay)
      $('.sets_ghost_elapsed').html(record.found_ghosts - localStorage.getItem("b_sets_ghost"))
      localStorage.setItem("dt_sets_ghost",record.found_ghosts)

    if record.found_isoghosts
      if record.found_isoghosts > localStorage.getItem("b_sets_isoghost")
        $('.sets_isoghost_elapsed').addClass('scored')
        Meteor.setTimeout((-> $('.sets_isoghost_elapsed').removeClass('scored')), cdelay)
      $('.sets_isoghost_elapsed').html(record.found_isoghosts - localStorage.getItem("b_sets_isoghost"))
      localStorage.setItem("b_sets_isoghost",record.found_isoghosts)
)

Template.card.helpers
  card: () ->
    return Cards.findOne({_id: this.card_mid})

Template.textcard.helpers
  card: () -> return Cards.findOne({_id: this.card_mid})

Template.history.helpers
 matches: () ->
   game_id = 0
   matches = Matches.find({game_id: game_id}, {sort: {date: -1}})
  typeSymbol: (type) ->
    if type == 'normal'
      return 'N'
    else if type == 'ghost'
      return 'G'
    else if type == 'isoghost'
      return 'I'
    else if type == 'super'
      return 'S'
  niceDate: (time) ->
    return moment(time).format('YYYY-MM-DD hh:mm:ss');

Template.matchcard.helpers
  card: () ->
    c = Cards.findOne({_id: this.valueOf()})
    return c


Template.globalGame.helpers
  gamecards: () ->
    game_id = 0
    gc = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: 1}})
    cardIds = gc.map (c) -> return c.card_mid
    all = Cards.find({_id: {$in: cardIds}}).fetch()
    all = gc.fetch()
    chunks = []
    if (window.innerHeight > window.innerWidth)
      size = 3
    else
      size = 4

    #console.log("all : " + all.length)
    while (all.length > size)
      chunks.push({ row: all.slice(0, size)})
      all = all.slice(size)
    chunks.push({row: all});
    #console.log("all : " + all.length)
    return chunks

Template.cardrow.helpers
  cardDisplayType: ->
    return Session.get("interface-type")

Template.textcard.helpers
  numbers: (index) ->
    return numbers[index]
  colors: (index) ->
    return colors[index]
  shades: (index) ->
    return shades[index]
  shapes: (index, number) ->
    plural = if number > 0 then 's' else ''
    return shapes[index] + plural

Template.card.helpers
  numbers: (index) ->
    return numbers[index]
  colors: (index) ->
    return colors[index]
  shades: (index) ->
    return shades[index]
  shapes: (index, number) ->
    plural = if number > 0 then 's' else ''
    return shapes[index] + plural
  shapearray: (number) ->
    a = []
    for i in [0..number]
      a.push(i+1)
    return a
  shader: (shade,color) ->
    if shade == 1
      return "fill: url(#" + colors[color] + "-stripes);"
    else if shade == 2
      return "fill: " + colors[color] + ";"
    else if shade == 0
      return "fill: none;"

Template.matchcard.helpers
  numbers: (index) ->
    return numbers[index]
  colors: (index) ->
    return colors[index]
  shades: (index) ->
    return shades[index]
  shapes: (index, number) ->
    plural = if number > 0 then 's' else ''
    return shapes[index] + plural
  shapearray: (number) ->
    a = []
    for i in [0..number]
      a.push(i+1)
    return a
  shader: (shade,color) ->
    if shade == 1
      return "fill: url(#" + colors[color] + "-stripes);"
    else if shade == 2
      return "fill: " + colors[color] + ";"
    else if shade == 0
      return "fill: none;"
