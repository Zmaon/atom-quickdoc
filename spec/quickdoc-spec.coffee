Quickdoc = require '../lib/quickdoc'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Quickdoc", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('quickdoc')

  describe "when the quickdoc:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.quickdoc')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'quickdoc:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.quickdoc')).toExist()

        quickdocElement = workspaceElement.querySelector('.quickdoc')
        expect(quickdocElement).toExist()

        quickdocPanel = atom.workspace.panelForItem(quickdocElement)
        expect(quickdocPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'quickdoc:toggle'
        expect(quickdocPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.quickdoc')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'quickdoc:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        quickdocElement = workspaceElement.querySelector('.quickdoc')
        expect(quickdocElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'quickdoc:toggle'
        expect(quickdocElement).not.toBeVisible()
