package fux;

#if sys
import sys.FileSystem;
#end

class Build {

	macro public static function playlist() {
		var a = FileSystem.readDirectory('res/video/live');
		for( f in a ) {

		}
		return macro $v{a};
	}

}
