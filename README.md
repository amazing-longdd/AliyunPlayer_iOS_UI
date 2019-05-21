# AliyunPlayer_iOS_UI


### 因为项目涉及到视频加密，服务器又架在阿里云，所以没有办法 只有选择 这个阿里云的视频播放框架，按照官网集成之后 发现最新版本SDK把UI部分移除了 做成了一个Demo开源，没办法 只有去 Demo里面把以前的AliyunVodPlayerView给剥离出来，使得可以快速集成。

### 项目里面 AliPlayerView 文件夹就是从Demo里面剥离出来的UI层，Resources是我整理之后相关的图片资源（代码里面的引用也已经改了），al_loader.gif是加载菊花gif，zh-Hans.lproj是Demo里面使用到了的国际化资源。


## 简单使用步骤
1. 使用pod集成AliyunPlayer_iOS，获取核心SDK
2. 把这里的所有东西复制到自己的项目中，引入AliyunVodPlayerView
```objc
#import "AliyunVodPlayerView.h"
```
3. 初始化
```swift
//设置播放器
private func setupPlayer(){

playerView = AliyunVodPlayerView.init(frame: CGRect.init(x: 0, y: 0, width: ConstData.SCREEN_WIDTH, height: ConstData.SCREEN_WIDTH))
playerView.delegate = self
videoView.addSubview(playerView)

playerView.setAutoPlay(true)
//这里根据自己的情况看使用什么播放方式
playerView.playPrepare(withVid: , playAuth: )

}
```
4. 代理方法参考 AliyunVodPlayerViewDelegate

> 大家可以根据自己的情况来增减UI的东西 , 最后讲一句 从Demo里面扣出来这些 真的 很费神
