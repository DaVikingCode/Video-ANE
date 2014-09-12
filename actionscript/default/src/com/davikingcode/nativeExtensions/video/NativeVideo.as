package com.davikingcode.nativeExtensions.video {

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class NativeVideo extends EventDispatcher {

		private static var _instance:NativeVideo;

		public static function getInstance():NativeVideo {
			return _instance;
		}

		public function NativeVideo() {

			_instance = this;
		}

		public function init():void {
		}

	}
}