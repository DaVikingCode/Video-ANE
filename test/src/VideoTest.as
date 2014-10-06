package {

	import aze.motion.eaze;

	import com.davikingcode.nativeExtensions.video.NativeVideo;
	import com.davikingcode.nativeExtensions.video.VideoObject;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="1024", height="768")]

	/**
	 * @author Aymeric
	 */
	public class VideoTest extends Sprite {
		
		[Embed(source="/../../embed/logo.png")]
		private const logoBitmap:Class;
		
		private var _video:NativeVideo;
		private var _patch:PatchRun;
		private var _bounds:Rectangle = new Rectangle(0, 0, 480 / 2, 214);
		
		private var _movie:VideoObject;
		
		public function VideoTest() {
				
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_video = new NativeVideo(stage);
			
			_movie = _video.addVideo("videos/trailer", "mov", VideoObject.MODE_LOOP, _bounds.x, _bounds.y, _bounds.width, _bounds.height);
			
			_video.addVideo("videos/sample_iPod", "m4v", VideoObject.MODE_LOOP, _bounds.x, 150, _bounds.width, _bounds.height);
			
			// we can display bitmapData on top of the video!
			_movie.displayBitmapDataOverlay(new logoBitmap().bitmapData, 50, 50, 150, 120);
			
			_patch = new PatchRun();
			
			_patch.x = stage.fullScreenWidth - _patch.width >> 1;
			_patch.y = stage.fullScreenHeight - _patch.height >> 1;
			addChild(_patch);
			
			stage.addEventListener(MouseEvent.CLICK, _click);
			
			_rdmPosition();
		}

		private function _rdmPosition():void {
			
			eaze(_video.videos[1]).delay(1).to(0.2, {x:Math.random() * stage.stageWidth / 2, y:Math.random() * stage.stageHeight / 2}).onComplete(_rdmPosition);
			
			eaze(_video.videos[1]).to(1, {volume:Math.random()}, false);
		}

		private function _click(mEvt:MouseEvent):void {
			
			_patch.x = mouseX;
			_patch.y = mouseY;
			
			eaze(_movie).to(0.5, {x:mouseX / 2, y:mouseY / 2});
		}
	}
}
