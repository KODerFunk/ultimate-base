###
 *  front-end js helpers
 *    0.3.3.alpha / 2010-2011
 *    Karpunin Dmitry / Evrone.com
 *    koderfunk_at_gmail_dot_com
###

@DEBUG_MODE ?= false
@TEST_MODE ?= false
@LOG_TODO ?= true

@cout = =>
  args = _.toArray(arguments)
  method = if args[0] in ['log', 'info', 'warn', 'error', 'assert', 'clear'] then args.shift() else 'log'
  if @DEBUG_MODE and console?
    method = console[method]
    if method.apply?
      method.apply(console, args)
    else
      method(args)
  return args[0]

@_cout = =>
  console.log(arguments)  if console?
  arguments[0]

@deprecate = (subject, instead = null) =>
  @cout 'error', "`#{subject}` DEPRECATED!#{if instead then " Use instead `#{instead}`" else ''}"

@todo = (subject, location = null, numberOrString = null) =>
  if @LOG_TODO
    @cout 'warn', "TODO: #{subject}#{if location then " ### #{location}" else ''}#{if numberOrString then (if _.isNumber(numberOrString) then ":#{numberOrString}" else " > #{numberOrString}") else ''}"

@args = (a) ->
  @deprecate 'arg()', '_.toArray()'
  r = []
  Array::push.apply(r, a)  if a.length > 0
  r

@logicalXOR = (a, b) ->
  ( a and not b ) or ( not a and b )

@bound = (number, min, max) ->
  Math.max(min, Math.min(max, number))



@getParams = ->
  q = location.search.substring(1).split('&')
  r = {}
  for e in q
    t = e.split('=')
    r[decodeURIComponent(t[0])] = decodeURIComponent(t[1])
  r

@respondFormat = (url, format = null) ->
  aq = url.split('?')
  ah = aq[0].split('#')
  ad = ah[0].split('.')
  currentFormat = if ad.length > 1 and not /\//.test(ad[ad.length - 1]) then ad.pop() else ''
  return currentFormat  unless format?
  return url  if format is currentFormat
  ad.push format  if format
  ah[0] = ad.join('.')
  aq[0] = ah.join('#')
  aq.join('?')



###########   Deprecated   ###########

@isset = (obj) =>
  @deprecate 'isset(obj)', '_.isUndefined(obj) OR "obj isnt undefined" OR "obj?'
  obj isnt undefined

@isString = (v) =>
  @deprecate 'isString(v)', '_.isString(v)'
  _.isString v

@isNumber = (v) =>
  @deprecate 'isNumber(v)', '_.isNumber(v)'
  not isNaN(parseInt(v))

@isJQ = (obj) ->
  @deprecate 'isJQ(obj)', 'obj instanceof jQuery'
  _.isObject(obj) and _.isString(obj.jquery)

@uniq = (arrOrString) ->
  @deprecate 'uniq(a)', '_.uniq(a)'
  isStr = _.isString(arrOrString)
  return arrOrString  unless isStr or _.isArray(arrOrString)
  r = []
  r.push(e)  for e in arrOrString  when not _.include(r, e)
  if isStr then r.join('') else r

@regexpSpace = /^\s*$/
@regexpTrim = /^\s*(.*?)\s*$/

@strTrim = (s) =>
  @deprecate "strTrim(s)", "_.trim(s)"
  s.match(@regexpTrim)[1]



@rails_data = {}

@rails_scope = (controller_name, action_name, scopedCloasure = null, scopedCloasureArguments...) =>
  @deprecate 'rails_scope'
  return false if _.isString(controller_name) and controller_name isnt @rails_data['controller_name']
  return false if _.isString(action_name)     and action_name     isnt @rails_data['action_name']
  if _.isFunction(scopedCloasure)
    arguments[2] scopedCloasureArguments...
  true

$ =>
  @rails_data = $('body').data()
