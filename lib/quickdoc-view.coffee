module.exports =
class QuickdocView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('quickdoc')

    # Create message element
    docframe = document.createElement('iframe')
    # message.textContent = "The Quickdoc package is Alive! It's ALIVE!"
    # message.classList.add('message')
    @element.appendChild(docframe)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
