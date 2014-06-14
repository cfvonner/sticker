component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.clean = new sticker.preprocessors.Clean();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "process()", function(){

			it( "should delete all the files passed to it", function(){
				var testFiles = [ "/resources/clean/test1.txt", "/resources/clean/test2.txt", "/resources/clean/test3.txt", "/resources/clean/test4.txt" ];

				for( var file in testFiles ){
					if ( !FileExists( file ) ) {
						FileWrite( file, "some content" );
					}
				}

				clean.process( source=testFiles );

				for( var file in testFiles ){
					expect( FileExists( file ) ).toBe( false );
				}
			} );
		} );
	}
}