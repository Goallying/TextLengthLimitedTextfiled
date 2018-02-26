//
//  UITextField+Limit.m
//  JT
//
//  Created by 朱来飞 on 2018/2/26.
//  Copyright © 2018年 zhulaifei. All rights reserved.
//

#import "UITextField+Limit.h"
#import <objc/runtime.h>
static void * LengthKey = @"LengthKey";

@implementation UITextField (Limit)

- (void)setLimitedLength:(NSInteger)limitedLength{
    objc_setAssociatedObject(self, LengthKey, @(limitedLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged|UIControlEventValueChanged];
    
}
- (NSInteger)limitedLength{
   return  [objc_getAssociatedObject(self, LengthKey) integerValue];
}
- (void)inputChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position)
    {
        if (toBeString.length > self.limitedLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitedLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:self.limitedLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitedLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end
