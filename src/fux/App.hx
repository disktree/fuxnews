package fux;

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

	static var current : Int;
	static var video : VideoElement;

	static function loadVideo( name : String ) {
		video.src = 'video/$name.mp4';
		video.currentTime = Math.random() * 3;
		//video.playbackRate = 4;
	}

	static inline function loadLiveVideo( name : String ) {
		loadVideo( 'live/$name' );
	}

	static function loadChannel( index : Int ) {

		if( index < 0 ) index = 0;
		else if( index >= playlist.length ) index = playlist.length;

		if( current == null ) {
			//
		}

		current = index;

		var channel = playlist[current];
		if( channel.index == null ) channel.index = 0 else {
			if( ++channel.index >= channel.video.length ) channel.index = 0;
		}

		var file = channel.video[channel.index];
		loadLiveVideo( file );
	}

	static function loadNextChannel() {
		if( ++current >= playlist.length ) current = 0;
		loadChannel( current );
	}

	static function loadPrevChannel() {
		current = (current == 0) ? playlist.length-1 : current-1;
		loadChannel( current );
	}

	static function main() {

		window.onload = function(){

			video = cast document.getElementById( 'live' );
			video.muted = true;
			video.autoplay = true;
			//video.loop = true;
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
				var channel = playlist[current];
				if( ++channel.index >= channel.video.length ) channel.index = 0;
				loadLiveVideo( channel.video[channel.index] );
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
			trace(index);
			//var state = (stateItem == null) ? 0 : Std.parseInt( stateItem );
			*/
			playlist.shuffle();
			var index = Std.int( Math.random() * (playlist.length-1) );
			loadChannel( index );

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
