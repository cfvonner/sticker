component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.less = new sticker.preprocessors.Less();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "process()", function(){

			it( "should take the incoming LESS file and convert it to a CSS file", function(){
				var lessFile    = "/resources/LESS/thisIsSomeLESS.less";
				var cssFile     = "/resources/LESS/thisIsSomeLESS.less.css";
				var expectedCss = FileRead( "/resources/LESS/thisIsSomeLESS.less.expectedcss" );

				if ( FileExists( cssFile ) ) {
					FileDelete( cssFile );
				}
				less.process( source=[ lessFile ], destination=cssFile );
				expect( FileExists( cssFile ) ).toBe( true );
				expect( FileRead( cssFile ) ).toBe( expectedCss );
			} );
		} );
	}
}