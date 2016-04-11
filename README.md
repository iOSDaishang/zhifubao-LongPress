# zhifubao-LongPress
//长按button事件
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    self.currentBtn = (UIButton *)longPress.view;
    CGPoint location = [longPress locationInView:self];
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        self.beganPoint = location;
        self.currentBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.currentBtn.backgroundColor = [UIColor grayColor];
        
        [self bringSubviewToFront:self.currentBtn];
        
        long index = [self.buttonArr indexOfObject:longPress.view];
        [self.buttonArr removeObject:self.currentBtn];
        [self.buttonArr insertObject:self.emptyBtn atIndex:index];
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        long index = [self.buttonArr indexOfObject:self.emptyBtn];
        
        [self.buttonArr removeObject:self.emptyBtn];
        [self.buttonArr insertObject:self.currentBtn atIndex:index];
        self.currentBtn.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.4 animations:^{
            
            [self setNewView];
        } completion:^(BOOL finished) {
            
            self.currentBtn.backgroundColor = [UIColor whiteColor];
            [self sendSubviewToBack:self.currentBtn];
        }];
    }
    //计算相对位移
    CGRect currentRcet = self.currentBtn.frame;
    currentRcet.origin.x += location.x - self.beganPoint.x;
    currentRcet.origin.y += location.y - self.beganPoint.y;
    self.currentBtn.frame = currentRcet;
    self.beganPoint = location;
    
    __weak typeof(self)weakSelf = self;
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (btn.tag == weakSelf.dataArr.count - 1)
        {
            return;
        }
        if (CGRectContainsPoint(btn.frame, location) && btn != longPress.view)
        {
            
            [weakSelf.buttonArr removeObject:weakSelf.emptyBtn];
            [weakSelf.buttonArr insertObject:weakSelf.emptyBtn atIndex:idx];
            
            *stop = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                //重新设置单元位置
                [weakSelf setNewView];
            }];
        }
    }];
}
