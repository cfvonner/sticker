component output=false {

	public any function process( required array source, required string destination ) output=false {
		var log = request.__dummyPreProcessorLog ?: [];

		log.append( arguments );
	}

}