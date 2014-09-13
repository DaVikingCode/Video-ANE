package {

	import aze.motion.eaze;

	import com.davikingcode.nativeExtensions.video.NativeVideo;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Aymeric
	 */
	public class VideoTest extends Sprite {
		
		private var _video:NativeVideo;
		private var _patch:PatchRun;
		private var _bounds:Rectangle = new Rectangle(0, 0, 480 / 2, 214);
		
		public function VideoTest() {
			
			_video = new NativeVideo(stage);
			
			_video.init("videos/trailer", "mov", _bounds.x, _bounds.y, _bounds.width, _bounds.height);
			
			_patch = new PatchRun();
			
			_patch.x = (stage.stageWidth - _patch.width) * 0.65;
			_patch.y = stage.stageHeight - _patch.height >> 1;
			addChild(_patch);
			
			trace(stage.stageWidth, stage.stageHeight, stage.fullScreenWidth, stage.fullScreenHeight);
			
			stage.addEventListener(MouseEvent.CLICK, _click);
		}

		private function _click(mEvt:MouseEvent):void {
			
			_patch.x = mouseX;
			_patch.y = mouseY;
			
			eaze(_video).to(0.5, {x:mouseX - _bounds.width / 2, y:mouseY - _bounds.height / 2});
			
			trace(mouseX, mouseY);
		}
	}
}
