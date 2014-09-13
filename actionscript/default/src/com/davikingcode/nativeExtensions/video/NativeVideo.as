package com.davikingcode.nativeExtensions.video {

	import flash.display.Stage;
	import flash.events.EventDispatcher;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		private var _stage:Stage;
		private var _x:Number;
		private var _y:Number;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo(stage:Stage) {

			_instance = this;

			_stage = stage;
		}

		public function init(url:String, type:String, posX:Number = 0, posY:Number = 0, width:Number = 480, height:Number = 320):void {
		}

		public function get x():Number {
			return _x;
		}

		public function set x(value:Number):void {
			_x = value;
		}

		public function get y():Number {
			return _y;
		}

		public function set y(value:Number):void {
			_y = value;
		}

	}
}