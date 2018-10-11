package fux;

#if sys
import haxe.macro.Expr;
import sys.FileSystem;
using om.Path;
#end

class Build {

	macro public static function playlist( path : String ) {
		var list = new Map<String,Int>();
		for( folder in FileSystem.readDirectory( path ) ) {
			list.set( folder, FileSystem.readDirectory( '$path/$folder' ).length );
		}
		var map : Array<Expr> = [];
		for( k in list.keys() ) {
			map.unshift( macro $v{k} => $v{list.get( k )} );
		}
		return macro $a{map};
	}

}
