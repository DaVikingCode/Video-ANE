package com.davikingcode.nativeExtensions.video {

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public var videos:Vector.<VideoObject>;

		private var _stage:Stage;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo(stage:Stage) {

			_instance = this;
			_stage = stage;

			videos = new Vector.<VideoObject>();
		}

		public function addVideo(url:String, type:String, posX:Number = 0, posY:Number = 0, width:Number = 320, height:Number = 480):void {

			videos.push(new VideoObject(null, videos.length, posX, posY));
		}

	}
}