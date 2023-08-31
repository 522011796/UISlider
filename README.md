<img width="571" alt="image" src="https://github.com/522011796/UISlider/assets/36726234/bbc5d471-ec05-4f65-bcbc-bca80e1960f1">



# UISlider
- 1、最小值
- 2、最大值
- 3、最小值背景色
- 4、最大值背景色
- 5、thumb大小
- 6、thumb颜色
- 7、thumb宽度
- 8、thumb是否显示
- 9、根据value设置默认thumb位置
- 10、圆角大小
- 11、最小值时候的图标
- 12、最大值时候的图标
- 13、slider的高度和宽度

使用:
```
WYUISlider *slider = [[WYUISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
slider.laygroundColor = [UIColor blueColor];
slider.radius = 5;
slider.minimumValue = 0;
slider.maximumValue = 10;
slider.value = 10;
slider.thumbColor = [UIColor redColor];
slider.mininumImage = @"close";
slider.maxinumImage = @"network_state_icon";
slider.iconImageHeight = 35;
slider.iconImageWidth = 35;
slider.iconImageOffsetLeft = 30;
slider.thumbViewWidth = 20;
slider.thumbHidden = NO;
slider.touchSliderValueChange = ^(CGFloat value,BOOL isEnd) {
  //isEnd: yes 表示拖动完毕后执行, no 表示拖动连续执行
}
```
