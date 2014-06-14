/**
 * I am a PreProcessorDefinition bean, I represent a single asset in a bundle
 */
component accessors=true output=false {

	property name="preprocessor" type="any";
	property name="directories"  type="array";
	property name="source"       type="array";
	property name="filter"       type="function";
	property name="destination"  type="any";
	property name="options"      type="struct";

	public struct function getMemento() output=false {
		var keys = [ "preprocessor", "directories", "source", "destination", "filter", "options" ];
		var memento = {};

		for( var key in keys ){
			if ( !IsNull( variables[ key ] ) ) {
				memento[ key ] = variables[ key ];
			}
		}

		return memento;
	}

}