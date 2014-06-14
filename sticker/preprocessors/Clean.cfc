/**
 * I am a Sticker pre-processor
 * I delete any of the files passed to me
 */
component output=false {

	public void function process( required array source ) output=false {
		for( var file in source ) { FileDelete( file ); }
	}

}

