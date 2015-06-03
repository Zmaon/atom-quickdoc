QuickdocView = require './quickdoc-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
shell = require('shell')

module.exports = Quickdoc =
  quickdocView: null
  modalPanel: null
  subscriptions: null

  config:
    base_urls:
      type: 'string'
      title: 'Set your custom documentation sources'
      description: 'Ex: {"php":"http://php.net/function.","default":"http://devdocs.io/#q="}'
      default: '{}'

  activate: (state) ->
    @quickdocView = new QuickdocView(state.quickdocViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @quickdocView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'quickdoc:lookup': => @lookup()

    @loadConfig()

    atom.config.onDidChange 'quickdoc.base_urls', ({newValue, oldValue}) =>
      @loadConfig()

  loadConfig: () ->
    path = atom.packages.resolvePackagePath("quickdoc")
    config = JSON.parse fs.readFileSync path + '/config.json'

    @base_urls = config.base_urls

    try
      custom_urls = JSON.parse atom.config.get('quickdoc.base_urls')

      if custom_urls
        for key, val of custom_urls
          @base_urls[key] = val
    catch error

    # console.log @base_urls

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @quickdocView.destroy()

  serialize: ->
    quickdocViewState: @quickdocView.serialize()

  lookup: ->
    if editor = atom.workspace.getActiveTextEditor()
        selection = editor.getWordUnderCursor()

        if selection and selection.match(/[a-z0-9]+/i)
            grammar_name = editor.getGrammar().name.toLowerCase()

            if @base_urls[grammar_name]
                shell.openExternal(@base_urls[grammar_name] + selection)
            else
                shell.openExternal(@base_urls.default + selection)

    # if !@modalPanel.isVisible()
    #   @modalPanel.show()
