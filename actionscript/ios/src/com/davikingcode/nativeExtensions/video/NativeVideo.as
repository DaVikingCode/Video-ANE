package com.davikingcode.nativeExtensions.video {

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public var extensionContext:ExtensionContext;

		private var _x:Number;
		private var _y:Number;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo() {

			_instance = this;

			extensionContext = ExtensionContext.createExtensionContext("com.davikingcode.nativeExtensions.Video", null);

			if (!extensionContext)
				throw new Error( "Video native extension is not supported on this platform." );

		}

		public function init(url:String, type:String, posX:Number = 0, posY:Number = 0, width:Number = 480, height:Number = 320):void {

			_x = posX;
			_y = posY;

			extensionContext.call("init", url, type, _x, _y, width, height);
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