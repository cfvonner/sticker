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
		var src                = root & ReReplace( definition.getSource(), "^/", "" );
		var dest               = root & ReReplace( definition.getDestination(), "^/", "" );

		preProcessorObject.process(
			  source      = [ src ]
			, destination = dest
		);
	}

}