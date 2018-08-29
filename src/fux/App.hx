package fux;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.VideoElement;

using om.ArrayTools;
using om.StringTools;

typedef Playlist = Array<Channel>;

typedef Channel = {
	var name : String;
	var video : Array<String>;
	@:optional var index : Int;
}

class App {

	static var playlist : Playlist = [
		{
			name: 'tucker-1',
			video: [
				'tucker-4.1.1',
				'tucker-4.1.2',
			]
		},
		{
			name: 'tucker-2',
			video: [
				'tucker-5.1.1',
				'tucker-5.1.2',
				'tucker-5.1.3',
			]
		},
		{
			name: 'tucker-3',
			video: [
				'tucker-6.1.1',
				'tucker-6.1.2',
				'tucker-6.1.3',
				'tucker-6.1.4',
				'tucker-6.1.5',
			]
		},
		{
			name: 'tucker-4',
			video: [
				'tucker-7.1.1',
				'tucker-7.1.2',
				'tucker-7.1.3',
				'tucker-7.1.4',
			]
		},
		{
			name: 'tucker-5',
			video: [
				'tucker-7.2.1',
				'tucker-7.2.2',
				'tucker-7.2.3',
			]
		},
		/*
		{
			name: 'unknown',
			video: [
				'cnn-2.1.1',
				'cnn-2.2.1',
				'cnn-2.2.2',
				'cnn-2.3.1',
				'ingraham-1.1.1',
				'ingraham-1.1.1',
				'ingraham-1.2.1',
				'ingraham-1.2.2',
				'ingraham-1.2.3',
				'tucker-3.2.1',
			]
		},
		*/
		{
			name: 'connway',
			video: [
				'cnn-1.1.1',
				'cnn-1.1.2',
				'cnn-1.1.3',
				'cnn-1.1.4',
				'cnn-1.1.5',
			]
		},
		{
			name: 'brian',
			video: [
				'cnn-1.2.1',
				'cnn-1.2.2',
				'cnn-1.2.3',
			]
		},
		{
			name: 'cuomo',
			video: [
				'cuomo-1.1.1',
				'cuomo-1.1.2',
				'cuomo-1.1.3',
				'cuomo-1.1.4',
				'cuomo-1.1.5',
				'cuomo-1.1.6',
				'cuomo-1.1.7',
				'cuomo-1.1.8'
			]
		},
		{
			name: 'stone',
			video: [
				'tucker-6.2.1',
				'tucker-6.2.2',
				'tucker-6.2.3',
			]
		},
		{
			name: 'jeannie',
			video: [
				'jeannie-1.1.1',
				'jeannie-1.1.2',
				'jeannie-1.1.3',
				'jeannie-1.1.4',
				'jeannie-1.1.5',
				'jeannie-1.1.6',
			]
		},
		{
			name: 'rudy',
			video: [
				'jeannie-1.2.1',
				'jeannie-1.2.2',
				'jeannie-1.2.3',
				'jeannie-1.2.4',
				'jeannie-1.2.5',
				'jeannie-1.2.6',
				'jeannie-1.2.7'
			]
		}
	];

	static var video : VideoElement;
	static var channel : Channel;
	static var index : Int; // Channel index

	static function loadNextChannel() {
		if( ++index >= playlist.length-1 ) index = 0;
		channel = playlist[index];
		loadVideo();
	}

	static function loadPrevChannel() {
		if( --index < 0 ) index = playlist.length-1;
		channel = playlist[index];
		loadVideo();
	}

	static function loadNextVideo() {
		if( channel.index >= channel.video.length-1 ) loadNextChannel();
		else {
			channel.index++;
			loadVideo();
		}
	}

	static function loadVideo() {
		var name = channel.video[channel.index];
		console.log(name);
		video.src = 'video/live/$name.mp4';
		video.currentTime = Math.random() * 2; // Slighty random start time offset
		//video.playbackRate = 8;
	}

	static function main() {

		window.onload = function(){

			console.info('FuxNews');

			video = cast document.getElementById( 'live' );
			video.muted = true;
			video.autoplay = true;
			/*
			video.addEventListener( 'loadstart', function(e){
				//background.play();
			}, false );
			video.addEventListener( 'play', function(e){

			}, false );
			video.addEventListener( 'pause', function(e){
				//trace(e);
			}, false );
			*/
			video.addEventListener( 'ended', function(e){
				loadNextVideo();
			}, false );

			/*
			var storage = js.Browser.getSessionStorage();
			var stateItem = storage.getItem('fuxnews');
			trace(stateItem);
			var index = 0;
			if( stateItem == null ) {
				playlist.shuffle();
			} else {
				index = Std.parseInt( stateItem );
			}
			//var state = (stateItem == null) ? 0 : Std.parseInt( stateItem );
			*/

			for( ch in playlist ) {
				ch.index = 0;
				ch.video.shuffle();
			}

			playlist.shuffle();

			index = 0;
			channel = playlist[index];
			loadVideo();

			document.body.onclick = e -> {
				if( video.readyState == 4 ) loadNextChannel();
			}
			document.body.oncontextmenu = e -> {
				e.preventDefault();
				if( video.readyState == 4 )  loadPrevChannel();
			}

			/*
			window.onbeforeunload = e -> {
				if( current != null ) storage.setItem( 'fuxnews', Std.string(current) );
				return null;
			}
			*/
		}
	}

}
