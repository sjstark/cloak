###
Make a boilerplate Nuxt config while accepting some options
###

# Deps
mergeConfig = require './merger'
defaults = require 'lodash/defaults'

# Concerns that make up the whole boilerplate config
coffeescript = require './concerns/coffeescript.coffee'
components = require './concerns/components.coffee'
craft = require './concerns/craft.coffee'
meta = require './concerns/meta.coffee'
polyfill = require './concerns/polyfill.coffee'
pwa = require './concerns/pwa.coffee'
styles = require './concerns/styles'
title = require './concerns/title.coffee'

# Export merging function
module.exports = (options) ->

	# Make default options
	options = defaults options,

		# The name of the site
		siteName: 'New Site'

		# Polyfill.io keys
		polyfills: [
			'default'
			'URL'
			'NodeList.prototype.forEach'
			'IntersectionObserver'
			'Element.prototype.remove'
			'Object.values'
		]

		# Craft _typenames for page routes
		pageTypenames: []

	# Merge all the concerns together
	mergeConfig.apply null, [
		coffeescript options
		components options
		craft options
		meta options
		polyfill options
		pwa options
		styles options
		title options
	]
