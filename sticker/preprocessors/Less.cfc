/**
 * I am a Sticker pre-processor
 * I take any LESS files as input and output CSS files :)
 */
component output=false {

// CONSTRUCTOR
	public Less function init( required string baseImportPath ) output=false {
		var rhinoWrapper = new sticker.util.RhinoWrapper( "/sticker/lib/rhino/rhino-1.7r4.jar" );

		rhinoWrapper.registerCfc( cfc=this, name="lessImportReader" );
		rhinoWrapper.loadJs( ExpandPath( "/sticker/lib/less/source-map-0.1.31.js"         ) );
		rhinoWrapper.loadJs( ExpandPath( "/sticker/lib/less/less-1.7.1.js"                ) );
		rhinoWrapper.loadJs( ExpandPath( "/sticker/preprocessors/javascript/lessProxy.js" ) );

		_setRhinoWrapper( rhinoWrapper );
		_setBaseImportPath( arguments.baseImportPath );

		return this;
	}

// THE 'PROCESS' METHOD USED BY STICKER
	public void function process( required array source, required string destination, boolean sourceMap=false, any sourceMapFilename ) output=false {
		if ( arguments.source.len() > 1 ) {
			throw(
				  type    = "sticker.Less.tooManyInputFiles"
				, message = "The LESS preprocessor for sticker can only convert a single LESS file into a single CSS file."
				, details = "Received destination [#arguments.destination#] and source files #SerializeJson( arguments.source )#"
			);
		}
		var lessCode     = FileRead( arguments.source[1] );
		var lessFilePath = arguments.source[1];
		var args         = [ lessCode, lessFilePath, arguments.sourceMap ];

		if ( arguments.sourceMap ) {
			args[2] = _calculateRelativePath( sourceMapFilename, lessFilePath );
			args.append( _calculateRelativePath( destination, sourceMapFilename ) );
		}

		var compilationResult = _getRhinoWrapper().callJs(
			  method = "compileLess" // see /sticker/preprocessors/javascript/lessProxy.js
			, args   = args
		);

		FileWrite( arguments.destination, compilationResult[ "css" ] );
		if ( arguments.sourceMap ) {
			FileWrite( arguments.sourceMapFilename, compilationResult[ "sourcemap" ] );
		}
	}

// HELPER METHOD THAT THE LESS.JS CODE WILL CALL TO READ @IMPORT FILES WITH
	public string function readImport( importPath, importedFromFileInfo ) output=false {
		var currentDirectory = importedFromFileInfo[ 'currentDirectory' ] ?: "";
		var fullImportPath   = currentDirectory & importPath;

		if ( FileExists( fullImportPath ) ) {
			return FileRead( fullImportPath );
		}

		var basePath = _getBaseImportPath();
		fullImportPath = ListAppend( basePath, importPath, "/" );

		if ( FileExists( fullImportPath ) ) {
			return FileRead( fullImportPath );
		}

		return "";
	}

// PRIVATE HELPERS
	private string function _calculateRelativePath( required string basePath, required string relativePath ) output=false {
		var baseDirectory     = GetDirectoryFromPath( basePath );
		var basePathArray     = ListToArray( baseDirectory, "\/" );
		var relativePathArray = ListToArray( relativePath, "\/" );
		var finalPath         = []
		var pathStart         = 0;
		var i                 = 0;

		if ( relativePath.startsWith( baseDirectory ) ) {
			return Right( relativePath, Len( relativePath ) - Len( baseDirectory ) );
		}

		/* Define the starting path (path in common) */
		for ( i=1; i <= basePathArray.len(); i++ ) {
			if ( basePathArray[i] != relativePathArray[i] ) {
				pathStart = i;
				break;
			}
		}

		if ( pathStart EQ 0 ) {
			ArrayAppend( finalPath, "." );
			pathStart = ArrayLen( basePathArray );
		}

		/* Build the prefix for the relative path (../../etc.) */
		for ( i=ArrayLen( basePathArray ) - pathStart; i GTE 0; i=i-1 ) {
			if ( ArrayLen( finalPath ) and finalPath[1] eq "." ) {
				ArrayDeleteAt( finalPath, 1 );
			}
			ArrayAppend( finalPath, ".." );
		}

		/* Build the relative path */
		for ( i=pathStart; i LTE ArrayLen(relativePathArray); i=i+1 ) {
			ArrayAppend( finalPath, relativePathArray[i] );
		}

		return ArrayToList( finalPath, "/" );
	}

// GETTERS AND SETTERS
	private any function _getRhinoWrapper() output=false {
		return _rhinoWrapper;
	}
	private void function _setRhinoWrapper( required any rhinoWrapper ) output=false {
		_rhinoWrapper = arguments.rhinoWrapper;
	}

	private string function _getBaseImportPath() output=false {
		return _baseImportPath;
	}
	private void function _setBaseImportPath( required string baseImportPath ) output=false {
		_baseImportPath = arguments.baseImportPath;
	}
}