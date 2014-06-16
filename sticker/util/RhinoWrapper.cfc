/**
 * A utility to bluntly wrap a lot of the common
 * logic needed when interacting with Rhino
 *
 * It may be blunting a lot of potentially required sharpness,
 * but for our purposes it should make interaction 87.45% easier
 */
component output=false {

// CONSTRUCTOR
	/**
	 * I am the constructor, tell me where to find the rhino jar
	 *
	 * @rhinoJarPath.hint Location of the rhino jar file
	 */
	public RhinoWrapper function init( required string rhinoJarPath ) output=false {
		_setupRhinoContext( arguments.rhinoJarPath );
		_setupDummyBrowserEnvironment();
		_setupCFMLHelperEnvironment();

		return this;
	}

// PUBLIC API METHODS
	public void function loadJs( required string input ){
		var getInputStreamFromString = function( js ){ return CreateObject( "java", "java.io.ByteArrayInputStream" ).init( arguments.js.getBytes() ); };
		var getInputStreamFromFile   = function( filepath ){ return CreateObject( "java", "java.io.FileInputStream" ).init( arguments.filePath ) };
		var inputStream              = FileExists( arguments.input ) ? getInputStreamFromFile( arguments.input ) : getInputStreamFromString( arguments.input );
		var reader                   = CreateObject( "java", "java.io.InputStreamReader" ).init( inputStream );

		try {
			_getContext().evaluateReader( _getScope(), reader, "", 1, NullValue() );
		} catch( any e ) {
			rethrow;
		} finally {
			reader.close();
		}
	}

	public any function callJs( required string method, array args=[] ){
		var scope      = _getScope();
		var jsFunction = getGlobalVariable( arguments.method );

		return _getContext().call( _getContextFactory(), jsFunction, scope, scope, arguments.args );
	}

	public void function registerCfc( required any cfc, required string name ) output=false {
		var jsVersionOfCfc = _getContext().javaToJS( arguments.cfc, _getScope() );

		callJs(
			  method = "registerCfc"
			, args   = [ jsVersionOfCfc, arguments.name ]
		);
	}

	public void function putGlobalVariable( required string name, required any value, string addToVariable="cfml" ) output=false {
		var jsVariable = getGlobalVariable( arguments.addToVariable );

		jsVariable.put( arguments.name, jsVariable, arguments.value );
	}

	public any function getGlobalVariable( required string name ) output=false {
		return _getScope().get( arguments.name, _getScope() );
	}

// PRIVATE HELPERS
	private void function _setupRhinoContext( required string rhinoJarPath ) output=false {
		var contextFactory = CreateObject( "java", "org.mozilla.javascript.ContextFactory", arguments.rhinoJarPath );
		var context        = contextFactory.enterContext();
		var global         = CreateObject( "java", "org.mozilla.javascript.tools.shell.Global", arguments.rhinoJarPath );

		context.setOptimizationLevel( -1 );
		global.init( context );

		_setContextFactory( contextFactory );
		_setContext( context );
		_setScope( context.initStandardObjects( global ) );
	}

	private void function _setupDummyBrowserEnvironment() output=false {
		loadJs( "var arguments = [ '' ], exports = {}, location = { port : 0 }, document = { getElementsByTagName : function(name) {return []; } }, window = {}, print = function() {}, quit = function() {}, readFile = function() { return ''; };" );
	}

	private void function _setupCFMLHelperEnvironment() output=false {
		var js = "var cfml          = { pageContext : null, cfcs : {} }"
		       & "  , registerCfc   = function( cfc, name ){ cfml.cfcs[ name ] = cfc }"
		       & "  , callCfcMethod = function( cfc, method, args ){ return cfml.cfcs[ cfc ].call( cfml.pageContext, method, args ); };"

		loadJs( js );
		putGlobalVariable( "pageContext", _getContext().javaToJS( getPageContext(), _getScope() ) );
	}

// GETTERS AND SETTERS
	private any function _getContextFactory() output=false {
		return _contextFactory;
	}
	private void function _setContextFactory( required any contextFactory ) output=false {
		_contextFactory = arguments.contextFactory;
	}

	private any function _getContext() output=false {
		return _context;
	}
	private void function _setContext( required any context ) output=false {
		_context = arguments.context;
	}

	private any function _getScope() output=false {
		return _scope;
	}
	private void function _setScope( required any scope ) output=false {
		_scope = arguments.scope;
	}


}