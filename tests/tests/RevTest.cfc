component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.rev = new sticker.preprocessors.Rev();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "process()", function(){

			it( "should generate a revision hash based on the content of each file and rename the source files according to the rename function argument", function(){
				var testFiles = [ "/resources/rev/test1.txt", "/resources/rev/test2.txt", "/resources/rev/test3.txt", "/resources/rev/test4.txt" ];
				var rename    = function( source, rev ){
					return ReReplace( source, "\.txt", rev & ".txt" );
				};

				// clean slate
				DirectoryList( "/resources/rev", false, "path", "*.txt" ).each( function( path ){
					FileDelete( path );
				} );

				// create test files
				for( var file in testFiles ){
					if ( !FileExists( file ) ) {
						FileWrite( file, file );
					}
				}

				// hopefully rename them with revision numbers
				rev.process( source=testFiles, rename=rename );

				// test that what we hoped for is true
				for( var file in testFiles ){
					var revFileName = rename( file, Left( LCase( Hash( file ) ), 8 ) );

					expect( FileExists( file ) ).toBe( false );
					expect( FileExists( revFileName ) ).toBe( true );
				}
			} );
		} );
	}
}