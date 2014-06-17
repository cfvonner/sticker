module.exports = {
	existsSync : function() {
		return "todo!"; // e.g. return String( callCfcMethod( 'nodeFs', 'existsSync', arguments ) )
	},

	statSync : function() {
		return { isFile : function(){ return true; } }; // e.g. return String( callCfcMethod( 'nodeFs', 'statSync', arguments ) )
	},

	readFileSync : function() {
		return "todo!"; // e.g. return String( callCfcMethod( 'nodeFs', 'readFileSync', arguments ) )
	}
};