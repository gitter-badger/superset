@initScore = (type) ->
  if !localStorage.getItem("sets_" + type)
    localStorage.setItem("sets_" + type,0)
  $('.sets_' + type).html(localStorage.getItem("sets_" + type))
  console.log("dt-" + type + ": " + localStorage.getItem("dt_sets_" + type) + " b-" + type + ": " + localStorage.getItem("b_sets_" + type))
  $('.sets_' + type + '_elapsed').html(localStorage.getItem("dt_sets_" + type) - localStorage.getItem("b_sets_" + type))
  if (typeof(localStorage.getItem("dt_sets_" + type)) == 'undefined')
    localStorage.setItem("dt_sets_" + type, 0)
  if (typeof(localStorage.getItem("b_sets_" + type)) == 'undefined')
    localStorage.setItem("b_sets_" + type, 0)


Template.nav.helpers
  statistics: ->
    s = Statistics.findOne({game: game})
    if s && !Session.get("score_init")
      console.log("init score")
      console.log(localStorage.getItem("b_sets_normal"))
      if !parseInt(localStorage.getItem("b_sets_normal"))
        localStorage.setItem("b_sets_normal", s.found_sets)
        localStorage.setItem('dt_sets_normal',s.found_sets)
      if !parseInt(localStorage.getItem("b_sets_super"))
          localStorage.setItem("b_sets_super", s.found_supers)
          localStorage.setItem('dt_sets_super',s.found_supers)
      if !parseInt(localStorage.getItem("b_sets_ghost"))
        localStorage.setItem("b_sets_ghost", s.found_ghosts)
        localStorage.setItem('dt_sets_ghost',s.found_ghosts)
      if !parseInt(localStorage.getItem("b_sets_isoghost"))
          localStorage.setItem("b_sets_isoghost", s.found_isoghosts)
          localStorage.setItem('dt_sets_isoghost',s.found_isoghosts)
      if !parseInt(localStorage.getItem("b_sets_superghost"))
          localStorage.setItem("b_sets_superghost", s.found_superghosts)
          localStorage.setItem('dt_sets_superghost',s.found_superghosts)

      localStorage.setItem('dt_sets_normal',s.found_sets)
      localStorage.setItem('dt_sets_super',s.found_supers)
      localStorage.setItem('dt_sets_ghost',s.found_ghosts)
      localStorage.setItem('dt_sets_isoghost',s.found_isoghosts)
      localStorage.setItem('dt_sets_superghost',s.found_superghosts)

      for gameType in gameTypes
        initScore(gameType)

      Session.set("score_init",1)
    return s
  buttonstate: (name,value) ->
    if Session.get(name) == 'true'
      return 'pressed'

# Template.nav.rendered = () ->
