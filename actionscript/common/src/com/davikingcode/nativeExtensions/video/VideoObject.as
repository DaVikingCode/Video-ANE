package com.davikingcode.nativeExtensions.video {

	import flash.external.ExtensionContext;

	public class VideoObject extends Object {

		public var extensionContext:ExtensionContext;

		private var _index:uint;
		private var _x:Number;
		private var _y:Number;

		public function VideoObject(extensionContext:ExtensionContext, index:uint, posX:uint, posY:uint) {

			this.extensionContext = extensionContext;
			_index = index;
			_x = posX;
			_y = posY;
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

		private function _changePosition():void {

			if (extensionContext)
				extensionContext.call("changePosition", _index, _x, _y);
		}
	}
}
