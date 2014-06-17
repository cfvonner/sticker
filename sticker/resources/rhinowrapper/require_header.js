( function( exports, module  ){
    var _parentPath = "${parentPath}";
    var require = function( id ) {
        if (typeof arguments[0] !== 'string') throw 'USAGE: require(moduleId)';

        var moduleFunction = callCfcMethod( 'rhinoWrapper', 'fetchRequiresContent', [ _parentPath, id ] )
          , exports = {}
          , module = { id: id, exports: exports };

        if ( moduleFunction ) {
            try {
                moduleFunction( exports, module );
            }
            catch(e) {
                throw 'Unable to require source code from "' + id + '": ' + e.toSource();
            }

            exports = module.exports || exports;

        } else {
            throw 'The requested module cannot be returned: no content for id: "' + id + '"';
        }

        return exports;
    };
