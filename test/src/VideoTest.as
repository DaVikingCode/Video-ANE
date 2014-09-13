package {

	import aze.motion.eaze;

	import com.davikingcode.nativeExtensions.video.NativeVideo;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class VideoTest extends Sprite {
		
		private var _video:NativeVideo;
		private var _patch:PatchRun;
		private var _bounds:Rectangle = new Rectangle(0, 0, 480 / 2, 214);
		
		public function VideoTest() {
			
			_video = new NativeVideo(stage);
			
			_video.addVideo("videos/trailer", "mov", _bounds.x, _bounds.y, _bounds.width, _bounds.height);
			
			_video.addVideo("videos/sample_iPod", "m4v", _bounds.x, 150, _bounds.width, _bounds.height);
			
			_patch = new PatchRun();
			
			_patch.x = (stage.stageWidth - _patch.width) * 0.65;
			_patch.y = stage.stageHeight - _patch.height >> 1;
			addChild(_patch);
			
			trace(stage.stageWidth, stage.stageHeight, stage.fullScreenWidth, stage.fullScreenHeight);
			
			stage.addEventListener(MouseEvent.CLICK, _click);
			
			setTimeout(_rdmPosition, 1000);
		}

		private function _rdmPosition():void {
			
			eaze(_video.videos[1]).to(0.2, {x:Math.random() * stage.stageWidth, y:Math.random() * stage.stageHeight});
			
			setTimeout(_rdmPosition, 1000);
		}

		private function _click(mEvt:MouseEvent):void {
			
			_patch.x = mouseX;
			_patch.y = mouseY;
			
			eaze(_video.videos[0]).to(0.5, {x:mouseX - _bounds.width / 2, y:mouseY - _bounds.height / 2});
			
			trace(mouseX, mouseY);
		}
	}
}
