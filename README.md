# flutter_notes
 flutter_notes
 
 Flutter Dart QQ技术交流群：979966470
 
本篇练习看似简单，但是已经将应用编写的大部分需要用的功能都贯穿起来进行了实践、并提供了比较好的解决方案，将开发中可能会遇到的很多问题和难点进行了一一解决。

在进行综合实践编写前，我们先整理下我们这里用到的一些知识点：
* 引导页（PageView）
* 顶部ToolBar（AppBar）
* 列表（CustomScrollView）
* 日历（三方库：flutter_custom_calendar）
* 权重（Flexible、Expanded）
* 导航组件（CupertinoTabBar）
* 弹窗（BottomSheet、SnackBar）
* 输入框（TextField）
* 通信（EventBut）
* 路由
* 下拉刷新（RefreshIndicator）
* 数据库（官方库：sqflite）
* 时间格式化
* 生命周期监听
* 返回键拦截
* List的操作
* 复杂布局实现
* 其他
  
那么我们这个综合实践，就通过以上的一些Widget和技术进行实现一个完整的日记本应用，也可以快速提升我们的开发实战水平。

我们先简单介绍下我们要实现的应用的功能：
日记本有引导页，具备列表显示功能、日记的新建、查看阅读、编辑功能，并加入了搜索功能。日记的数据存储的本地手机数据库内，提供3个页面进行切换。

1.首先是引导页：引导页作为应用的一个基本的功能，会为大家实现并提供解决方案。

2.应用页面基本框架：包括一个底部导航栏，带三个页面切换，并在切换时保持页面数据状态。

3.日记的增删改查功能：存储在手机自带数据库中。

4.日记的搜索功能。

5.关于页面。

6.列表时时通知更新功能。

7.复制剪贴板功能等。

**项目开发环境：**
Windows 10

Flutter v1.7.8

Android Studio 3.4

Dart 2.2.0


**项目的dart代码结构如下：**

![dart代码结构](https://raw.githubusercontent.com/jaychou2012/flutter_notes/master/screenshot/20190804213521.png)

**使用到的第三方库如下：**

* sqflite：数据库操作

* path_provider：目录路径的读取

* oktoast：实现Toast提示

* event_bus：通信

* flutter_custom_calendar：日历功能

**部分效果预览图：**

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/gifhome_540x960_31s.gif)

静态效果图：

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-210042.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-214452.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-210101.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-210108.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-214556.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-210138.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-213326.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-214522.jpg)

![实践篇效果图](https://github.com/jaychou2012/flutter_notes/raw/master/screenshot/Screenshot_20190804-214548.jpg)

## 后续更新计划：
这个项目也会持续更新，开源。后续更新内容：

登录页、注册页、密码锁的绘制、日历事件的完善、收藏页、主题切换、天气和表情及图片的添加等。

预览APK地址：https://github.com/jaychou2012/flutter_notes/raw/master/app-release.apk


## 《从零开始学Flutter》已出版


### 新书涵盖Flutter最新的大部分的组件技术和内容，从零开始深入讲解其中涉及的技术点，包括：Dart基础 、Flutter基础组件、Flutter开发规范、路由与生命周期、Http网络请求、应用打包与发布等，值得购买阅读。


![从零开始学Flutter](https://img10.360buyimg.com/n1/jfs/t1/150105/31/6483/200868/5f448b12E10484765/20a772cdd2d0a857.jpg "从零开始学Flutter")


### 纸质书购买：

[京东](https://item.jd.com/10020767293895.html "京东")         [天猫](https://detail.tmall.com/item.htm?spm=a220m.1000858.1000725.46.4d964d77KORSb8&id=625677553628&areaId=500100&user_id=1932014659&cat_id=2&is_b=1&rn=cfb373631608a3f9e449fc0a225a090d "天猫")  [当当](http://product.dangdang.com/1675961491.html "当当")
