component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.less = new sticker.preprocessors.Less( baseImportPath="/resources/LESS/globals" );
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

			it( "should throw a useful error when we attempt to compile more than a single LESS file at a time", function(){
				expect( function(){
					less.process( source=[ "/some/file.less", "/another/file.less" ], destination="destination.css" );
				} ).toThrow( type="sticker.Less.tooManyInputFiles" );
			} );

			it( "should try to find and process import directives in LESS files that are relative to the source LESS file", function(){
				var lessFile    = "/resources/LESS/subfolder/some.less";
				var cssFile     = "/resources/LESS/subfolder/some.less.css";
				var expectedCss = FileRead( "/resources/LESS/subfolder/some.less.expectedcss" );

				if ( FileExists( cssFile ) ) {
					FileDelete( cssFile );
				}
				less.process( source=[ lessFile ], destination=cssFile );
				expect( FileExists( cssFile ) ).toBe( true );
				expect( FileRead( cssFile ) ).toBe( expectedCss );
			} );

			it( "should try to find and process import directives in LESS files that are relative to the configured base path if it cannot find it relative to the LESS file", function(){
				var lessFile    = "/resources/LESS/subfolder/another.less";
				var cssFile     = "/resources/LESS/subfolder/another.less.css";
				var expectedCss = FileRead( "/resources/LESS/subfolder/another.less.expectedcss" );

				if ( FileExists( cssFile ) ) {
					FileDelete( cssFile );
				}
				less.process( source=[ lessFile ], destination=cssFile );
				expect( FileExists( cssFile ) ).toBe( true );
				expect( FileRead( cssFile ) ).toBe( expectedCss );
			} );

			it( "should generate a source map file when asked to do so", function(){
				var lessFile      = "/resources/LESS/sourcemaptest/sourcemap.less";
				var cssFile       = "/resources/LESS/sourcemaptest/sourcemap.less.css";
				var sourceMapFile = "/resources/LESS/sourcemaptest/sourcemap.less.css.map";
				var expectedCss   = FileRead( "/resources/LESS/sourcemaptest/sourcemap.less.expectedcss" );
				var expectedMap   = FileRead( "/resources/LESS/sourcemaptest/sourcemap.less.expectedmap" );

				if ( FileExists( cssFile ) ) {
					FileDelete( cssFile );
				}
				if ( FileExists( sourceMapFile ) ) {
					FileDelete( sourceMapFile );
				}

				less.process( source=[ lessFile ], destination=cssFile, sourceMap=true, sourceMapFilename=sourceMapFile );

				expect( FileExists( cssFile ) ).toBe( true );
				expect( FileRead( cssFile ) ).toBe( expectedCss );
				expect( FileExists( sourceMapFile ) ).toBe( true );
				expect( FileRead( sourceMapFile ) ).toBe( expectedMap );
			} );
		} );
	}
}