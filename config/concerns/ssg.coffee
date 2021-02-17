###
Prepare to statically generate the site using routes from a Craft query
###
flatten = require 'lodash/flatten'
once = require 'lodash/once'
getCraftPages = require '../queries/compiled/craft-pages'
{ getEntries } = require '../../services/craft.coffee'
{ isGenerating } = require('../helpers.coffee')
module.exports = ({ pageTypenames }) ->

	# Support falling back to a resolvable file on Netlify if a route didn't
	# exist when build was run.  We only want this to run when _not_ using
	# generate so we return true 404s.
	fallback: if isGenerating then false else '404.html'

	# Restrict the number of simulateneous requests so we don't consume too
	# many server connections.
	concurrency: 50

	# Don't use Nuxt 2.13 Crawler since we're explicitly creating all the
	# routes we care about and don't want to generate dead links.
	crawler: false

	# Sub folders, set to false to remove the trailing slashes
	subFolders: false

	# Add dynamic routes
	routes: once ->
		return [] unless isGenerating and pageTypenames.length
		routes = []

		# Loop through type combinations and add to
		console.log('  Fetching data for route generation');
		for typename in pageTypenames
			results = await getEntriesForTypename typename

			# Make the list of routes
			routes = [
				...routes,
				...flatten(results).map (entry) ->
					route: if entry.uri == '__home__' then '/' else "/#{entry.uri}"
					robots: entry.robots || []
					payload: entry
			]

# Make a query given a pageTypeName
getEntriesForTypename = (typename) ->
	[section, type ] = typename.split '_'
	getEntries
		query: getCraftPages
		variables: { section, type }
