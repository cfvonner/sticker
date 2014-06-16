/**
 * a wrapper function to make calling less compilation
 * simple through Rhino
 */

var compileLess = function( source, path ){
	var lessParser = new window.less.Parser( { filename : path } )
	  , css;

	lessParser.parse( source, function( e, root ){
		if ( e ) { throw( e ); }

		css = root.toCSS();
	} );

	return { css:css };
};

/**
 * Overriding the import function in LESS to use our CFC code to
 * handle the logic of reading @import url(...) files
 */
window.less.Parser.importer = function( path, currentFileInfo, callback, env ) {
	if ( path != null ) {
		try {
			var lessParser = new window.less.Parser()
			  , content    = callCfcMethod( "lessImportReader", "readImport", [ path, currentFileInfo ] );

			lessParser.parse( String( content ), function( e, root ){ callback( e, root, path ); } );
		} catch( e ) {
			callback( e );
		}
	}
};