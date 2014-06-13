component output=false {

	public any function process() output=false {
		var log = request.__dummyPreProcessorLog ?: [];

		log.append( arguments );
	}

}