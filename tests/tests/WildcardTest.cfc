component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.wildcard = new sticker.util.Wildcard();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "directoryList()", function(){

			it( "should return files and directories within the passed root directory that match the passed set of glob filters", function(){
				var result = wildcard.directoryList( ExpandPath( "/resources/wildcardFilesTest/" ), [ "**/*.min.*", "!**/*.css" ] );

				expect( result ).toBe([
					  ExpandPath( "/resources/wildcardFilesTest/somefolder/subfolder/another.min.js" )
					, ExpandPath( "/resources/wildcardFilesTest/somefolder/subfolder/some.min.js" )
				] );


			} );

		} );
	}

}