package com.davikingcode.nativeExtensions.video {

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.StageOrientationEvent;
	import flash.external.ExtensionContext;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public var extensionContext:ExtensionContext;

		public var videos:Array;

		private var _stage:Stage;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo(stage:Stage) {

			_instance = this;
			_stage = stage;

			videos = [];

			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, _stageOrientationChanging);

			extensionContext = ExtensionContext.createExtensionContext("com.davikingcode.nativeExtensions.Video", null);

			if (!extensionContext)
				throw new Error( "Video native extension is not supported on this platform." );

		}

		public function addVideo(url:String, type:String, posX:Number = 0, posY:Number = 0, width:Number = 320, height:Number = 480):void {

			extensionContext.call("addVideo", url, type, posX, posY, width, height, _stage.orientation);

			videos.push(new VideoObject(extensionContext, videos.length, posX, posY));
		}

		private function _stageOrientationChanging(stageOrientationEvt:StageOrientationEvent):void {

			extensionContext.call("changeOrientation", stageOrientationEvt.afterOrientation);
		}

	}
}