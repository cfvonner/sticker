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

			it ( "should return files in order that the filters come in with alphabetical order as a tie breaker", function(){
				var result = wildcard.directoryList( ExpandPath( "/resources/wildcardFilesTest/" ), [
					  "sortordertest/04.txt"
					, "sortordertest/07.txt"
					, "sortordertest/*.txt"
					, "!sortordertest/01.txt"
				] );

				expect( result ).toBe([
					  ExpandPath( "/resources/wildcardFilesTest/sortordertest/04.txt" )
					, ExpandPath( "/resources/wildcardFilesTest/sortordertest/07.txt" )
					, ExpandPath( "/resources/wildcardFilesTest/sortordertest/02.txt" )
					, ExpandPath( "/resources/wildcardFilesTest/sortordertest/03.txt" )
					, ExpandPath( "/resources/wildcardFilesTest/sortordertest/05.txt" )
					, ExpandPath( "/resources/wildcardFilesTest/sortordertest/06.txt" )
				] );
			} );

		} );
	}

}