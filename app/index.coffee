require('lib/setup')
Spine = require('spine')
Marked = require('marked/lib/marked')

template =
  layout: require('views/layout')
  sidebar: require('views/sidebar')
  content: require('views/content')

class App extends Spine.Controller
  elements:
    '#project-name': 'project_name'
    '#file-name': 'file_name'
    '#sidebar': 'sidebar'
    '#content': 'content'

  events:
    'click li.class': 'open_action'
    'click li.fun': 'open_action'

  constructor: ->
    super
    @html template.layout(@)

    $.getJSON '/api.json', (json) =>
      console.log(json)
      @files = json
      @sidebar.html(template.sidebar(@))


  open_action: (e) =>
    el          = $(e.currentTarget)
    file_index  = el.parents('.list:first').attr('data-file')

    @open_file(file_index)

  open_file: (file_index) ->
    @file = @files[file_index]
    @content.html(template.content(@))

  _format_content: (content) ->
    Marked(content)


module.exports = App
