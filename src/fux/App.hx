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
		}
	];

	static var current : Int;
	static var video : VideoElement;
	//static var background : VideoElement;
	//static var nextChannelVideo : VideoElement;

	static function loadVideo( name : String ) {
		video.src = 'video/$name.mp4';
		//video.playbackRate = 4;
		//video.currentTime = Math.random() * 5;
		//trace(video.src);
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

			/*
			background = cast document.getElementById( 'background' );
			//background.src = 'video/flag.mp4';
			background.oncanplaythrough = e -> {
				loadChannel(0);
			}
			*/

			var container = document.querySelector( 'fux-live' );

			//nextChannelVideo = document.createVideoElement();
			//nextChannelVideo.muted = true;
			//nextChannelVideo.autoplay = true;
			//container.appendChild( nextChannelVideo );

			video = cast document.getElementById( 'live' );
			video.muted = true;
			video.autoplay = true;
			//video.loop = true;
			video.addEventListener( 'loadstart', function(e){
				//background.play();
			}, false );
			video.addEventListener( 'play', function(e){
				//background.pause();
				/*
				var annel = playlist[current];
				var i = (channel.index == channel.video.length) ? 0 : channel.index + 1;
				var n = channel.video[i];
				var f = 'video/live/$n.mp4';
				//nextChannelVideo.src = f;
				//nextChannelVideo.pause();
				*/


			}, false );
			video.addEventListener( 'pause', function(e){
				//trace(e);
				//background.play();
			}, false );
			video.addEventListener( 'ended', function(e){
				var channel = playlist[current];
				/*
				video.remove();
				nextChannelVideo.id = 'video';
				container.appendChild( nextChannelVideo );
				video = nextChannelVideo;
				video.play();
				*/
				if( ++channel.index >= channel.video.length ) channel.index = 0;
				loadLiveVideo( channel.video[channel.index] );

			}, false );

			/*
			var music = document.createAudioElement();
			music.src = 'sound/music.mp3';
			music.autoplay = true;
			music.loop = true;
			music.volume = 0.4;
			*/

			var storage = js.Browser.getSessionStorage();
			var _state = storage.getItem('fuxnews');
			var state = (_state == null) ? 0 : Std.parseInt( _state );
			loadChannel( state );

			//trace( js.Object.keys(window) );
			//for( f in js.Object.keys(window).filter( s -> return s.startsWith('on') ) ) trace( f );

			document.body.onclick = e -> {
				loadNextChannel();
			}
			document.body.oncontextmenu = e -> {
				e.preventDefault();
				loadPrevChannel();
			}
			window.onbeforeunload = e -> {
				if( current != null ) storage.setItem( 'fuxnews', Std.string(current) );
				return null;
			}
		}
	}

}
