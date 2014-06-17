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
		_setupRequireJsHelpers();

		return this;
	}

// PUBLIC API METHODS
	/**
	 * I add javascript to the rhino context
	 *
	 * @input.hint Either a raw javascript string or filepath to a file that contains javascript
	 */
	public any function loadJs( required string input ){
		var getInputStreamFromString = function( js ){ return CreateObject( "java", "java.io.ByteArrayInputStream" ).init( arguments.js.getBytes() ); };
		var getInputStreamFromFile   = function( filepath ){ return CreateObject( "java", "java.io.FileInputStream" ).init( arguments.filePath ) };
		var inputStream              = FileExists( arguments.input ) ? getInputStreamFromFile( arguments.input ) : getInputStreamFromString( arguments.input );
		var reader                   = CreateObject( "java", "java.io.InputStreamReader" ).init( inputStream );
		var result                   = "";

		try {
			result = _getContext().evaluateReader( _getScope(), reader, "", 1, NullValue() );
		} catch( any e ) {
			rethrow;
		} finally {
			reader.close();
		}

		return result;
	}

	/**
	 * I allow you to call js methods that are registered in the global scope
	 *
	 * @method.hint Name of the method to call
	 * @args.hint   Array of arguments to pass to the method
	 */
	public any function callJs( required string method, array args=[] ){
		var scope      = _getScope();
		var jsFunction = getGlobalVariable( arguments.method );

		return _getContext().call( _getContextFactory(), jsFunction, scope, scope, arguments.args );
	}

	/**
	 * I register a CFC instance to the javascript context so it can later
	 * be called from JS with 'callCfcMethod( nameOfCfc, methodName, methodArgs )'
	 *
	 * @cfc.hint  Instantiated CFC
	 * @name.hint Name with which to register the CFC
	 */
	public void function registerCfc( required any cfc, required string name ) output=false {
		var jsVersionOfCfc = _getContext().javaToJS( arguments.cfc, _getScope() );

		callJs(
			  method = "registerCfc"
			, args   = [ jsVersionOfCfc, arguments.name ]
		);
	}

	/**
	 * I set variables in the javascript scope
	 *
	 * @name.hint          Name of the variable
	 * @value.hint         Value of the variable
	 * @addToVariable.hint Global variable on which to add this variable, e.g. 'window' or 'cfml' (default)
	 */
	public void function putGlobalVariable( required string name, required any value, string addToVariable="cfml" ) output=false {
		var jsVariable = getGlobalVariable( arguments.addToVariable );

		jsVariable.put( arguments.name, jsVariable, arguments.value );
	}

	/**
	 * I return a Mozilla Rhino javascript object that is the value of the named variable you wish to get
	 *
	 * @name.hint Name of the global variable you wish to get
	 */
	public any function getGlobalVariable( required string name ) output=false {
		return _getScope().get( arguments.name, _getScope() );
	}

	/**
	 * I import some javascript using the requiresJS module pattern used by NODE
	 * and return the exports / modules.exports variable of the included js
	 *
	 * @path.hint path to javascript file, can ommit the file extension
	 */
	public any function require( required string path ) output=false {
		var fullPath = ReFindNoCase( "\.js$", arguments.path ) ? arguments.path : arguments.path & ".js";
		var dir      = GetDirectoryFromPath( fullPath );
		var anonFunc = loadJs( _wrapJsForRequireJs( FileRead( fullPath ), dir ) );
		var module = loadJs( "( function(){ return { exports : {} } } )();" );

		anonFunc.call(
			  _getContext()
			, _getScope()
			, _getScope()
			, [ module['exports'], module ]
		);

		return module['exports'] ?: {};
	}

	public any function fetchRequiresContent( required string parentPath, required string id ) output=false {
		var isNodeCoreModule = ReFind( "^[a-z]", id );
		var fullPath         = "";

		if ( isNodeCoreModule ) {
			fullPath = "/resources/rhinowrapper/nodeCoreModules/#id#.js";
		} else {
			fullPath  = parentPath & id & ".js";
		}

		var directory = GetDirectoryFromPath( fullPath );
		var js        = _wrapJsForRequireJs( FileRead( fullPath ), directory );

		return loadJs( js );
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

	private void function _setupRequireJsHelpers() output=false {
		registerCfc( cfc=this, name="rhinoWrapper" );
	}

	private string function _wrapJsForRequireJs( required string js, required string parentPath ) output=false {
		var header = FileRead( "/sticker/resources/rhinowrapper/require_header.js" );
		var footer = FileRead( "/sticker/resources/rhinowrapper/require_footer.js" );

		header = Replace( header, "${parentPath}", parentPath, "all" );

		return header & arguments.js & footer;
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