package com.davikingcode.nativeExtensions.video {

	import flash.display.BitmapData;
	import flash.external.ExtensionContext;

	public class VideoObject extends Object {

		static public const MODE_LOOP:String = "MODE_LOOP";
		static public const MODE_MANUAL_CONTROL:String = "MODE_MANUAL_CONTROL";
		static public const MODE_PLAY_ONCE:String = "MODE_PLAY_ONCE";

		public var extensionContext:ExtensionContext;

		private var _url:String;
		private var _index:uint;
		private var _mode:String;
		private var _x:Number;
		private var _y:Number;

		private var _paused:Boolean = false;
		private var _volume:Number = 1;

		public function VideoObject(extensionContext:ExtensionContext, url:String, index:uint, mode:String, posX:Number, posY:Number) {

			this.extensionContext = extensionContext;

			_url = url;
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

		public function displayBitmapDataOverlay(bmpd:BitmapData, posX:Number, posY:Number, width:Number, height:Number):void {

			if (extensionContext)
				extensionContext.call("displayBitmapDataOverlay", _index, bmpd, posX, posY, width, height);
		}

		public function removeFirstBitmapData():void {

			if (extensionContext)
				extensionContext.call("removeFirstBitmapData", _index);
		}

		public function removeLatestBitmapData():void {

			if (extensionContext)
				extensionContext.call("removeLatestBitmapData", _index);
		}

		public function playAnimation(animName:String, startFrame:uint, endFrame:uint, directory:String, speed:Number, repeatCount:uint, posX:Number, posY:Number, width:Number, height:Number):void {

			if (extensionContext)
				extensionContext.call("playAnimation", _index, animName, startFrame, endFrame, directory, speed, repeatCount, posX, posY, width, height);
		}

		internal function updateIndex(index:uint):void {

			_index = index;
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

		public function get volume():Number {

			return _volume;
		}

		public function set volume(value:Number):void {

			_volume = value;

			if (extensionContext)
				extensionContext.call("changeSoundVolume", _index, _volume);
		}

		public function get url():String {

			return _url;
		}

		public function get index():uint {

			return _index;
		}

		private function _changePosition():void {

			if (extensionContext)
				extensionContext.call("changePosition", _index, _x, _y);
		}
	}
}
