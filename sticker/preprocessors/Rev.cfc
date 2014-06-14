/**
 * I am a Sticker pre-processor
 * I delete any of the files passed to me
 */
component output=false {

	public void function process( required array source, required function rename ) output=false {
		for( var filePath in source ) {
			var newFilePath = rename( filePath, _produceRevisionNumber( filePath ) );
			if ( newFilePath != filePath ) {
				FileMove( filePath, newFilePath );
			}
		}
	}

	private string function _produceRevisionNumber( required string filePath ) output=false {
		var content = FileRead( filePath );
		var hashed  = Hash( content );

		return Left( LCase( hashed ), 8 ); // more attractive + 8 chars reliable enough
	}

}