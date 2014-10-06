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

		public function addVideo(url:String, type:String, mode:String, posX:Number = 0, posY:Number = 0, width:Number = 320, height:Number = 480, speedRotation:Number = 0.55):VideoObject {

			var videoObject:VideoObject = new VideoObject(null, videos.length, mode, posX, posY);

			videos.push(videoObject);

			return videoObject;
		}

		public function removeVideo(videoObject:VideoObject):void {

			var videoIndex:int = videos.indexOf(videoObject);

			if (videoIndex == -1)
				throw new Error("videoObject's index is equal to -1.")

			videos.splice(videoIndex, 1);

			for (var i:uint = 0; i < videos.length; ++i)
				videos[i].updateIndex(i);
		}

		public function killAllVideos():void {
			videos.length = 0;
		}

	}
}