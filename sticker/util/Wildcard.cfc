/**
 * I am a utility class that wraps the Wildcard project for java
 * for efficient glob querying of directories
 *
 * See: https://github.com/EsotericSoftware/wildcard
 */
component output=false {

	public array function directoryList( required string directory, required array globFilters ) output=false {
		var paths = CreateObject( "java", "com.esotericsoftware.wildcard.Paths", ExpandPath( "/sticker/lib/wildcard-1.04.jar" ) ).glob( arguments.directory, globFilters );
		var files = paths.getFiles();
		var filePaths = [];

		for( var file in files ){
			filePaths.append( file.getPath() );
		}

		return filePaths;
	}

}