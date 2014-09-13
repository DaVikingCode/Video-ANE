package com.davikingcode.nativeExtensions.video {

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.StageOrientationEvent;
	import flash.external.ExtensionContext;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public var extensionContext:ExtensionContext;

		private var _stage:Stage;
		private var _x:Number;
		private var _y:Number;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo(stage:Stage) {

			_instance = this;
			_stage = stage;

			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, _stageOrientationChanging);

			extensionContext = ExtensionContext.createExtensionContext("com.davikingcode.nativeExtensions.Video", null);

			if (!extensionContext)
				throw new Error( "Video native extension is not supported on this platform." );

		}

		public function init(url:String, type:String, posX:Number = 0, posY:Number = 0, width:Number = 480, height:Number = 320):void {

			_x = posX;
			_y = posY;

			extensionContext.call("init", url, type, _x, _y, width, height, _stage.orientation);
		}

		private function _stageOrientationChanging(stageOrientationEvt:StageOrientationEvent):void {

			extensionContext.call("changeOrientation", stageOrientationEvt.afterOrientation);
		}

		public function get x():Number {

			return _x;
		}

		public function set x(value:Number):void {

			_x = value;

			extensionContext.call("changePosition", _x, _y);
		}

		public function get y():Number {

			return _y;
		}

		public function set y(value:Number):void {

			_y = value;

			extensionContext.call("changePosition", _x, _y);
		}

	}
}