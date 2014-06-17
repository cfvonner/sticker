component output=false {

// THE CONFIGURE METHOD (Sticker will call this)
// ----------------------------------------------
	public function configure( bundle ) output=false {
		_mapAssets( bundle );
		_setDependenciesAndSortOrder( bundle );
		_registerPreProcessors( bundle );
	}

// PRIVATE HELPERS
	private void function _mapAssets( bundle ) output=false {
		bundle.addAsset(
			  id   = "jquery-ui-css"
			, url  = "http://jquery.com/jqueryui.min.css"
		);

		bundle.addAssets(
			  directory   = "/css"
			, match       = "*.min.css"
			, idGenerator = function( path ){
				var id = ReplaceNoCase( arguments.path, "/", "-", "all" );
				id = ReReplace( id, "^-", "" );
				id = ReReplace( id, "\.min\.css$", "" );

				return id;
			  }
		);

		bundle.addAssets(
			  directory   = "/js"
			, match       = "*.min.js"
			, idGenerator = function( path ){
				var id = ReplaceNoCase( arguments.path, "/", "-", "all" );
				id = ReReplace( id, "^-", "" );
				id = ReReplace( id, "\.min\.js$", "" );

				return id;
			  }
		);
	}

	private void function _setDependenciesAndSortOrder( bundle ) output=false {
		bundle.asset( "jquery-ui-css"      ).before( "*" );
		bundle.asset( "css-some"           ).before( "*" ).dependsOn( "jquery-ui-css" );
		bundle.asset( "css-subfolder-more" ).before( "subfolder-another" ).dependsOn( "css-some" );
		bundle.asset( "js-someplugin"      ).dependents( "jquery" );
	}

	private void function _registerPreProcessors( bundle ) output=false {
		bundle.addPreProcessor(
			  preprocessor = "resources.preprocessors.DummyPreProcessor"
			, source       = [ "/css/**/*.css", "!/css/**/*.min.css" ]
			, destination  = function( source ){ return ReReplace( source, "\.css$", ".min.css" ); }
		);

		bundle.addPreProcessor(
			  preprocessor = "resources.preprocessors.DummyPreProcessor"
			, source       = [ "/js/*.js" ]
			, destination  = "/compiled/test.min.js"
		);
	}

}