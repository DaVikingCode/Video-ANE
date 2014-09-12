package com.davikingcode.nativeExtensions.video {

	import flash.events.Event;

	public class NativeVideoEvent extends Event {

		public function NativeVideoEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}
