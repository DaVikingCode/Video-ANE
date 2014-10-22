Video-ANE
=========

**iOS only at the moment.**

Displaying video in a AIR mobile project using Starling is complicated:
- Flash display list Video object is not efficient
- StageVideo may not have any things related to Starling on top of it and may only have 1 Video playing.
- [VideoTexture](https://forums.adobe.com/message/6615256) are still not available on mobile.

The goal of this ANE is to display a video, on top of everything. So let's say it's a StageVideo reverse class.

The movie is [Big Buck Bunny](http://www.bigbuckbunny.org/) and the character comes from the [Citrus Engine](http://citrusengine.com).

```actionscript3

_video = new NativeVideo(stage);
			
var movie:VideoObject = _video.addVideo("videos/trailer", "mov", VideoObject.MODE_LOOP, _bounds.x, _bounds.y, _bounds.width, _bounds.height);
			
_video.addVideo("videos/sample_iPod", "m4v", VideoObject.MODE_LOOP, _bounds.x, 150, _bounds.width, _bounds.height);

// 3 modes: MODE_LOOP, MODE_MANUAL_CONTROL (you will advance video time), MODE_PLAY_ONCE.

// we can display bitmapData on top of the video!
movie.displayBitmapData(new logoBitmap().bitmapData, 50, 50, 150, 120);

// and even animations (be sure to put the pngs in iOS package contents)
movie.playAnimation("Sprite-Ancre_%05d", 11, 75, "anims", 1.2, 1, 0, 0, 68, 68);

//we can tween video position:
eaze(movie).to(0.5, {x:mouseX / 2, y:mouseY / 2});

//we can move to a video part if the video mode is MODE_MANUAL_CONTROL
_video.videos[0].gotoVideoTime(2.43);

//remove a video (be careful it changes all videos index).
_video.removeVideo(movie);

//for removing all videos
_video.killAllVideos();

//pause, unpause video
_video.videos[1].paused = true;

//we may change video volume
_video.videos[1].volume = 0.3;

```

*We recommend to remove the video when the app `DEACTIVATE` and add it again when the `ACTIVATE`'s Event occurs.*
