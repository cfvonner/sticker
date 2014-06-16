/**
 * a wrapper function to make calling less compilation
 * simple through Rhino
 */

var compileLess = function( source, path, generateSourceMap, sourceMapURL ){
	var lessParser = new window.less.Parser( { filename : path } )
	  , css, sourcemap;

	lessParser.parse( source, function( e, root ){
		if ( e ) { throw( e ); }

		if ( generateSourceMap ) {
			css = root.toCSS({
				  sourceMap          : true
				, writeSourceMap     : function( map ){ sourcemap = map }
				, sourceMapGenerator : require( "source-map/source-map-generator" ).SourceMapGenerator
				, sourceMapBasepath  : ""
				, sourceMapRootpath  : ""
				, sourceMapURL       : sourceMapURL
				, outputSourceFiles : [ '']
			});
		} else {
			css = root.toCSS();
		}
	} );

	return { css:css, sourcemap:sourcemap };
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