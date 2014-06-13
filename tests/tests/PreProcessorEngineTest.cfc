component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.processor = new sticker.util.PreProcessorEngine();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "run()", function(){

			it( "should call the 'process' method of the passed preProcessorDefinition processor", function(){
				var testProcessor = new sticker.util.PreProcessorDefinition(
					  preprocessor = "resources.preprocessors.DummyPreProcessor"
					, source       = [ "/js/javascript.js" ]
					, destination  = "/compiled/javascript.min.js"
				);

				request.__dummyPreProcessorLog = []; // see /resources/preprocessors/DummyPreProcessor for what we do with this variable

				processor.run( definition=testProcessor, rootDirectory="/resources/bundles/bundle1/" );

				expect( request.__dummyPreProcessorLog.len() ).toBe( 1 );
				expect( request.__dummyPreProcessorLog[1] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/javascript.js" ]
					, destination = "/resources/bundles/bundle1/compiled/javascript.min.js"
				} );

			} );

			it( "should pass array of sources to 'process' method when multiple sources defined", function(){
				var testProcessor = new sticker.util.PreProcessorDefinition(
					  preprocessor = "resources.preprocessors.DummyPreProcessor"
					, source       = [ "/js/javascript.js", "/js/subfolder/anotherjsfile.js" ]
					, destination  = "/compiled/javascript.min.js"
				);

				request.__dummyPreProcessorLog = []; // see /resources/preprocessors/DummyPreProcessor for what we do with this variable

				processor.run( definition=testProcessor, rootDirectory="/resources/bundles/bundle1/" );

				expect( request.__dummyPreProcessorLog.len() ).toBe( 1 );
				expect( request.__dummyPreProcessorLog[1] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/subfolder/anotherjsfile.js", "/resources/bundles/bundle1/js/javascript.js" ]
					, destination = "/resources/bundles/bundle1/compiled/javascript.min.js"
				} );
			} );

			it( "should pass filtered array of sources to 'process' method when sources are supplied as an array of glob filters", function(){
				var testProcessor = new sticker.util.PreProcessorDefinition(
					  preprocessor = "resources.preprocessors.DummyPreProcessor"
					, source       = [ "**/*.js", "!**/*.min.js" ]
					, destination  = "/compiled/javascript.min.js"
				);

				request.__dummyPreProcessorLog = []; // see /resources/preprocessors/DummyPreProcessor for what we do with this variable

				processor.run( definition=testProcessor, rootDirectory="/resources/bundles/bundle1/" );

				expect( request.__dummyPreProcessorLog.len() ).toBe( 1 );
				expect( request.__dummyPreProcessorLog[1] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/subfolder/anotherjsfile.js", "/resources/bundles/bundle1/js/javascript.js" ]
					, destination = "/resources/bundles/bundle1/compiled/javascript.min.js"
				} );
			} );

			it( "should pass filtered array of sources to 'process' method when sources are supplied as an array of glob filters with additional function for filter", function(){
				var testProcessor = new sticker.util.PreProcessorDefinition(
					  preprocessor = "resources.preprocessors.DummyPreProcessor"
					, source       = [ "**/*.js", "!**/*.min.js" ]
					, filter       = function( path ){ return !ReFindNoCase( "subfolder", path ); }
					, destination  = "/compiled/javascript.min.js"
				);

				request.__dummyPreProcessorLog = []; // see /resources/preprocessors/DummyPreProcessor for what we do with this variable

				processor.run( definition=testProcessor, rootDirectory="/resources/bundles/bundle1/" );

				expect( request.__dummyPreProcessorLog.len() ).toBe( 1 );
				expect( request.__dummyPreProcessorLog[1] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/javascript.js" ]
					, destination = "/resources/bundles/bundle1/compiled/javascript.min.js"
				} );
			} );

			it( "should map source files to destination filenames when a function is passed to generate the destination filename", function(){
				var testProcessor = new sticker.util.PreProcessorDefinition(
					  preprocessor = "resources.preprocessors.DummyPreProcessor"
					, source       = [ "**/*.js" ]
					, destination  = function( source ){
						var dest = ListDeleteAt( source, ListLen( source, "/" ), "/" );
						    dest = ListChangeDelims( dest, "-", "/" );
						    dest = ReReplace( dest, "^-", "" );
						    dest = ReReplace( dest, "-$", "" );

						return "/compiled/#dest#.min.#ListLast( source, '.' )#";
					  }
				);

				request.__dummyPreProcessorLog = []; // see /resources/preprocessors/DummyPreProcessor for what we do with this variable

				processor.run( definition=testProcessor, rootDirectory="/resources/bundles/bundle1/" );

				expect( request.__dummyPreProcessorLog.len() ).toBe( 2 );
				expect( request.__dummyPreProcessorLog[1] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/subfolder/fa56e8c-myfile.min.js", "/resources/bundles/bundle1/js/subfolder/anotherjsfile.js" ]
					, destination = "/resources/bundles/bundle1/compiled/js-subfolder.min.js"
				} );
				expect( request.__dummyPreProcessorLog[2] ).toBe( {
					  source      = [ "/resources/bundles/bundle1/js/javascript.js" ]
					, destination = "/resources/bundles/bundle1/compiled/js.min.js"
				} );
			} );

		} );

	}

}