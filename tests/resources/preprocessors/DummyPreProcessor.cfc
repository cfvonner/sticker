component output=false {

	public any function init() output=false {
		var log = request.__dummyPreProcessorInitLog ?: [];

		log.append( arguments );
		return this;
	}

	public any function process( required array source, required string destination ) output=false {
		var log = request.__dummyPreProcessorLog ?: [];

		log.append( arguments );
	}

}