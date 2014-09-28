package com.davikingcode.nativeExtensions.video {

	import flash.display.BitmapData;
	import flash.external.ExtensionContext;

	public class VideoObject extends Object {

		static public const MODE_LOOP:String = "MODE_LOOP";
		static public const MODE_MANUAL_CONTROL:String = "MODE_MANUAL_CONTROL";
		static public const MODE_PLAY_ONCE:String = "MODE_PLAY_ONCE";

		public var extensionContext:ExtensionContext;

		private var _index:uint;
		private var _mode:String;
		private var _x:Number;
		private var _y:Number;

		private var _paused:Boolean = false;

		public function VideoObject(extensionContext:ExtensionContext, index:uint, mode:String, posX:Number, posY:Number) {

			this.extensionContext = extensionContext;

			_index = index;
			_mode = mode;
			_x = posX;
			_y = posY;
		}

		public function get mode():String {
			return _mode;
		}

		public function gotoVideoTime(time:Number):void {

			if (extensionContext && _mode == MODE_MANUAL_CONTROL)
				extensionContext.call("gotoVideoTime", _index, time);
		}

		public function displayBitmapData(bmpd:BitmapData, posX:Number, posY:Number, width:Number, height:Number):void {

			if (extensionContext)
				extensionContext.call("displayBitmapData", _index, bmpd, posX, posY, width, height);
		}

		public function get x():Number {

			return _x;
		}

		public function set x(value:Number):void {

			_x = value;

			_changePosition();
		}

		public function get y():Number {

			return _y;
		}

		public function set y(value:Number):void {

			_y = value;

			_changePosition();
		}

		public function get paused():Boolean {

			return _paused;
		}

		public function set paused(value:Boolean):void {

			_paused = value;

			if (extensionContext)
				extensionContext.call("paused", _index, _paused);
		}

		private function _changePosition():void {

			if (extensionContext)
				extensionContext.call("changePosition", _index, _x, _y);
		}
	}
}
