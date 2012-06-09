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

    # Spine.Route.setup()

    @routes
      '/:file': (params) =>
        @open_file(params.file)

    $.getJSON '/api.json', (json) =>
      console.log(json)
      @files = json
      @files_by_path = {}
      for file in @files
        @files_by_path[file.path] = file
      @sidebar.html(template.sidebar(@))

      Spine.Route.setup()


  open_action: (e) =>
    el          = $(e.currentTarget)
    file_index  = el.parents('.list:first').attr('data-file')
    file        = @files[file_index]
    @navigate "/#{file.path}"

  open_file: (path) ->
    @file = @files_by_path[path]
    @file_name.text(@file.basename)
    @content.html(template.content(@))

  _format_content: (content) ->
    Marked(content)


module.exports = App
