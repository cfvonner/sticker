/**
 * I am a PreProcessorDefinition bean, I represent a single asset in a bundle
 */
component accessors=true output=false {

	property name="preprocessor" type="string";
	property name="direcotries"  type="array";
	property name="source"       type="any";
	property name="destination"  type="any";

	public struct function getMemento() output=false {
		var keys = [ "preprocessor", "direcotries", "source", "destination" ];
		var memento = {};

		for( var key in keys ){
			if ( !IsNull( variables[ key ] ) ) {
				memento[ key ] = variables[ key ];
			}
		}

		return memento;
	}

}