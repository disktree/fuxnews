package fux;

import js.Browser.console;
import js.Browser.document;
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
		videoIndex = 0;
		loadVideo();
	}

	static function loadNextChannel() {
		if( ++channelIndex == channelKeys.length ) channelIndex = 0;
		videoIndex = 0;
		loadVideo();
	}

	static function loadNextVideo() {
		var numVideos = PLAYLIST.get( channelKeys[channelIndex] );
		if( ++videoIndex == numVideos ) {
			loadNextChannel();
		} else {
			loadVideo();
		}
	}

	static function loadVideo() {
		var channelKey = channelKeys[channelIndex];
		var src = 'video/live/'+channelKey+'/'+(videoIndex+1)+'.mp4';
		console.log(src);
		video.src = src;
		video.playbackRate = playbackRate;
	}

	static function main() {

		window.onload = function(){

			console.info('Fux News Network');

			video = cast document.getElementById( 'live' );
			video.muted = true;
			video.autoplay = true;
			video.addEventListener( 'ended', function(e){
				loadNextVideo();
			}, false );

			channelKeys = [for(k in PLAYLIST.keys())k];
			shufflePlaylist();
			loadVideo();

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
