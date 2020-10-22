package fux;

import js.html.URLSearchParams;
import js.Browser.console;
import js.Browser.document;
import js.Browser.navigator;
import js.Browser.window;
import js.html.Element;
import js.html.VideoElement;

using om.ArrayTools;
using om.StringTools;

class App {

	static var PLAYLIST : Map<String,Int> = Build.playlist('bin/video/live');

	static var video : VideoElement;
	static var channelKeys : Array<String>;
	static var channelIndex : Int;
	static var videoIndex : Int;
	static var playbackRate = 1.0;

	static function shufflePlaylist() {
		channelKeys.shuffle();
		channelIndex = videoIndex = 0;
	}

	static function loadPrevChannel() {
		if( channelIndex == 0 ) channelIndex = channelKeys.length-1;
		else channelIndex--;
		videoIndex = 1;
		loadVideo( videoIndex );
	}

	static function loadNextChannel() {
		if( ++channelIndex == channelKeys.length ) {
			channelIndex = 0;
		}
		videoIndex = 1;
		loadVideo( videoIndex );
	}

	static function loadNextVideo() {
		var numVideos = PLAYLIST.get( channelKeys[channelIndex] );
		if( videoIndex >= numVideos ) {
			loadNextChannel();
		} else {
			//videoIndex++;
			loadVideo( videoIndex+1 );
		}
	}

	static function loadVideo( index : Int ) {
		var channelKey = channelKeys[channelIndex];
		//var index = videoIndex+1;
		videoIndex = index;
		var id = channelKey+'/'+videoIndex;
		//console.log( id );
		video.src = 'video/live/'+id+'.mp4';
		video.playbackRate = playbackRate;
		var path = '?k=$channelKey&i=$videoIndex';
		window.history.replaceState( {}, null, path );
	}

	static function main() {

		window.onload = function(){

			console.info( '%cFuxNews™', 'color:#003265;' );

			trace(window.location);
			var path = window.location.search;
			trace(path);

			channelKeys = [for(k in PLAYLIST.keys())k];
			//channelIndex = 0; 
			//videoIndex = 1;
			shufflePlaylist();

			var path = window.location.search;
			if( path.length > 0 ) {
				var url = new URLSearchParams( path );
				var k = url.get('k');
				var i = url.get('i');
				for( j in 0...channelKeys.length ) {
					if( channelKeys[j] == k ) {
						channelIndex = j;
						videoIndex = Std.parseInt(i);
						var numVideos = PLAYLIST.get( channelKeys[channelIndex] );
						if( videoIndex > numVideos || videoIndex == 0 ) videoIndex = 1;
						break;
					}
				}
			} else {
				channelIndex = 0; 
				videoIndex = 1;
			}

			video = cast document.getElementById( 'live' );
			video.muted = true;
			video.autoplay = true;
			video.addEventListener( 'ended', function(e){
				loadNextVideo();
			}, false );

			loadVideo( videoIndex );

			document.body.onclick = e -> {
				if( video.readyState == 4 ) loadNextChannel();
			}
			document.body.oncontextmenu = e -> {
				e.preventDefault();
				if( video.readyState == 4 ) loadPrevChannel();
			}
			window.onkeydown = function(e) {
				//trace(e.keyCode);
				switch e.keyCode {
				case 37:
					if( video.readyState == 4 ) loadPrevChannel();
				case 39,13,32:
					if( video.readyState == 4 ) loadNextChannel();
				case 83: //s
					channelKeys.shuffle();
					channelIndex = videoIndex = 0;
				case 187: //+
					video.playbackRate = playbackRate = Math.min( playbackRate+1, 10 );
				case 189: //-
					video.playbackRate = playbackRate = Math.max( playbackRate-1, 1 );
				}
			}
		}
	}

}
