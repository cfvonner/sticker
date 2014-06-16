var compileLess = function( source, path ){
	var lessParser = new window.less.Parser( { filename : path } )
	  , css;

	lessParser.parse( source, function( e, root ){
		if ( e ) { throw( e ); }

		css = root.toCSS();
	} );

	return { css:css };
};