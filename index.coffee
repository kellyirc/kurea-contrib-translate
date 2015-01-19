module.exports = (Module) ->

	MsTranslator = require "mstranslator"

	class TranslateModule extends Module
		shortName: "Translate"
		helpText:
			default: "Translate some text between languages!"
		usage:
			default: "translate [from-language-code] [to-language-code] [text]"

		initTranslator: ->
			@translator = new MsTranslator
					client_id: 'Kurea2'
					client_secret: @apiKey

		constructor: (moduleManager) ->
			super moduleManager

			@apiKey = @getApiKey 'azure'

			if not @apiKey?
				console.log "No Azure access token was specified, so I won't be able to do translations."
			else
				@initTranslator()

			@addRoute "translate :from :to :text", (origin, route) =>
				if not @apiKey and @apiKey = @getApiKey 'azure'
					@initTranslator()
				if @apiKey
					[from, to, text] = [route.params.from, route.params.to, route.params.text]

					@translator.initialize_token () =>
						@translator.translate
							from: from
							to: to
							text: text
						, (err, text) =>
								@reply origin, "Error: #{err}" if err
								@reply origin, "Translation Result: #{text}"
				else
					@reply origin, "I can't translate without an API key!"