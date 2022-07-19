#import "YYLabel.h"

#import "YYAsyncLayer.h"
#import <libkern/OSAtomic.h>

#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation YYLabel

- (void)setText:(NSString *)text {
    _text = text.copy;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)contentsNeedUpdated {
    // do update
    [self.layer setNeedsDisplay];
}

#pragma mark - YYAsyncLayer

+ (Class)layerClass {
    return YYAsyncLayer.class;
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    // capture current state to display task
    NSString *text = _text;
    UIFont *font = _font;
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        //...
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) return;
        //在这里由于绘制文字会颠倒
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        }];
        NSAttributedString* str = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:self->_font}];
        CGContextSetTextPosition(context, 0, font.pointSize);
        
        CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str);
        CTLineDraw(line, context);
        
        CTFramesetterRef ref = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)str);
        CGPathRef path = CGPathCreateWithRect(CGRectZero, nil);
        CTFrameRef pic = CTFramesetterCreateFrame(ref, CFRangeMake(0, 0), path, nil);
        CTFrameDraw(pic, context);
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            // finished
        } else {
            // cancelled
        }
    };
    
    return task;
}
@end
