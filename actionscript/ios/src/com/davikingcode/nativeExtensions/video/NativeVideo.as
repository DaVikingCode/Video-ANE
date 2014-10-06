package com.davikingcode.nativeExtensions.video {

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.StageOrientationEvent;
	import flash.external.ExtensionContext;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public var extensionContext:ExtensionContext;

		public var videos:Vector.<VideoObject>;

		private var _stage:Stage;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo(stage:Stage) {

			_instance = this;
			_stage = stage;

			videos = new Vector.<VideoObject>();

			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, _stageOrientationChanging);

			extensionContext = ExtensionContext.createExtensionContext("com.davikingcode.nativeExtensions.Video", null);

			if (!extensionContext)
				throw new Error( "Video native extension is not supported on this platform." );

		}

		public function addVideo(url:String, type:String, mode:String, posX:Number = 0, posY:Number = 0, width:Number = 320, height:Number = 480, speedRotation:Number = 0.55):VideoObject {

			extensionContext.call("addVideo", url, type, mode, posX, posY, width, height, speedRotation, _stage.orientation);

			var videoObject:VideoObject = new VideoObject(extensionContext, videos.length, mode, posX, posY);

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

			extensionContext.call("removeVideo", videoIndex);
		}

		public function killAllVideos():void {

			extensionContext.call("killAllVideos");

			videos.length = 0;
		}

		private function _stageOrientationChanging(stageOrientationEvt:StageOrientationEvent):void {

			extensionContext.call("changeOrientation", stageOrientationEvt.afterOrientation);
		}

	}
}