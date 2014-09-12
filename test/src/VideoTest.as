package {

	import com.davikingcode.nativeExtensions.video.NativeVideo;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Aymeric
	 */
	public class VideoTest extends Sprite {
		
		private var _patch:PatchRun;

		public function VideoTest() {

			var video:NativeVideo = new NativeVideo();
			
			video.init();
			
			_patch = new PatchRun();
			
			_patch.x = (stage.stageWidth - _patch.width) * 0.65;
			_patch.y = stage.stageHeight - _patch.height >> 1;
			addChild(_patch);
			
			stage.addEventListener(MouseEvent.CLICK, _click);
		}

		private function _click(mEvt:MouseEvent):void {
			
			_patch.x = mouseX - _patch.width / 2;
			_patch.y = mouseY - _patch.height / 2;
		}
	}
}
