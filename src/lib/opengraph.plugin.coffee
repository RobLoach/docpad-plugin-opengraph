# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class OpenGraphPlugin extends BasePlugin
    # Name
    name: 'opengraph'

    # Constructor: true
    constructor: ->

      # Prepare
      super

      # Chain
      @

    # Called per document, for each extension conversion.
    renderDocument: (opts) ->
      # Prepare.
      {templateData} = opts

      # Load the document's Open Graph data.
      og = templateData.document.og or {}

      # Input some of the default data if it doesn't exist already.
      og.title ?= templateData.document.title if templateData.document.title?

      # Recursive function to build the Open Graph meta tags.
      parse = (data, name = "og") ->
        if typeof data == 'string'
          # Replace ":value" endings so that associative arrays have names.
          name = name.replace(':value', '')
          return "<meta property=\"#{name}\" content=\"#{data}\" />"
        else
          output = for parent, child of data
            parse(child, name + ':' + parent)
          return output

      for i, metatag of parse(og)
        # @todo Only manipulate the meta data of the single document rather
        # than globally.
        @docpad.blocks.meta.add(metatag)
