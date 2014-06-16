component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "init()", function(){

			it( "should return an instantiated RhinoWrapper with dummy window environment and CFML environment pre-loaded", function(){
				var wrapper = new sticker.util.RhinoWrapper( rhinoJarPath="/sticker/lib/rhino-1.7R4.jar" );
				var window = wrapper.getGlobalVariable( "window" );
				var cfml   = wrapper.getGlobalVariable( "cfml" );

				expect( IsSimpleValue( window ) ).toBe( false );
				expect( IsSimpleValue( cfml ) ).toBe( false );
				expect( IsDefined( "cfml.pageContext" ) ).toBe( true );
			} );

		} );

		describe( "callJs", function(){

			it( "should return the value of the javascript method we wish to call", function(){
				var wrapper = new sticker.util.RhinoWrapper( rhinoJarPath="/sticker/lib/rhino-1.7R4.jar" );

				wrapper.loadJs( "var testFunction = function( arg1 ){ return arg1 + ' world'; };" );

				expect( wrapper.callJs( "testFunction", [ "hello" ] ) ).toBe( "hello world" );
			} );

		} );
	}
}