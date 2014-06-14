/**
 * I am a utility class that wraps the Wildcard project for java
 * for efficient glob querying of directories
 *
 * See: https://github.com/EsotericSoftware/wildcard
 */
component output=false {

	/**
	 * I list the contents of the passed directory that matches the array of GLOB filters
	 *
	 * @directory.hint   Root directory of the listing
	 * @globFilters.hint Array of string GLOB filters with which to search the directory
	 */
	public array function directoryList( required string directory, required array globFilters ) output=false {
		var paths            = CreateObject( "java", "com.esotericsoftware.wildcard.Paths", ExpandPath( "/sticker/lib/wildcard-1.04.jar" ) );
		var exclusionFilters = globFilters.filter( function( fltr ){ return Left( fltr, 1 ) == "!"; } );
		var inclusionFilters = globFilters.filter( function( fltr ){ return Left( fltr, 1 ) != "!"; } );
		var filePaths        = StructNew( "linked" );

		// the oddness of this code is to do with ensuring that
		// files are returned in the order that matches the filter
		// order + the alphabetical order of matched files
		for( var fltr in inclusionFilters ){
			var filters = Duplicate( exclusionFilters );
			filters.prepend( fltr );

			var javaFiles = paths.glob( arguments.directory, filters ).getFiles();
			var files     = [];
			for( file in javaFiles ){
				files.append( file.getPath() );
			}
			files.sort( "textnocase" );
			files.each( function( file ){
				filePaths[ file ] = 1;
			} );
		}

		return filePaths.keyArray();
	}

}