/**
 * I provide methods for running preprocessor definitions
 */

component output=false {

	/**
	 * I execute the passed preProcessorDefinition method
	 *
	 * @preProcessorDefinition.hint an instantiated sticker.util.PreProcessorDefinition bean that will be executed
	 * @rootDirectory.hint          root directory used to resolve all relative paths in the definition
	 */
	public void function run( required PreProcessorDefinition definition, required string rootDirectory ) output=false {
		var preProcessorObject = CreateObject( definition.getPreProcessor() );
		var root               = ReReplace( arguments.rootDirectory, "(^/)$", "\1/" );
		var src                = definition.getSource();
		var dest               = root & ReReplace( definition.getDestination(), "^/", "" );

		if ( !IsArray( src ) ) {
			src = [ src ];
		}
		src = _resolveWildcardFileArray( arguments.rootDirectory, src );

		preProcessorObject.process(
			  source      = src
			, destination = dest
		);
	}

// PRIVATE HELPERS
	private array function _resolveWildcardFileArray( required string rootDirectory, required array globPatternArray ) output=false {
		var expandedRoot = ExpandPath( arguments.rootDirectory );
		var matches      = new Wildcard().directoryList( expandedRoot, arguments.globPatternArray );


		for( var i=1; i <= matches.len(); i++ ){
			var relative = Right( matches[i], Len( matches[i] ) - Len( expandedRoot ) );
			    relative = Replace( relative, "\", "/", "all" );

			matches[i] = arguments.rootDirectory & relative;
		}

		return matches;
	}

}