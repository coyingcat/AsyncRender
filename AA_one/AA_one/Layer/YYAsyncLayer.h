//
//  YYAsyncLayer.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<YYAsyncLayer/YYAsyncLayer.h>)
FOUNDATION_EXPORT double YYAsyncLayerVersionNumber;
FOUNDATION_EXPORT const unsigned char YYAsyncLayerVersionString[];
#import <YYAsyncLayer/YYSentinel.h>
#import <YYAsyncLayer/YYTransaction.h>
#else
#import "YYSentinel.h"
#import "YYTransaction.h"
#endif

@class YYAsyncLayerDisplayTask;

NS_ASSUME_NONNULL_BEGIN

/**
 The YYAsyncLayer class is a subclass of CALayer used for render contents asynchronously.
 
 @discussion When the layer need update it's contents, it will ask the delegate 
 for a async display task to render the contents in a background queue.
 */
@interface YYAsyncLayer : CALayer

@end


/**
 The YYAsyncLayer's delegate protocol. The delegate of the YYAsyncLayer (typically a UIView)
 must implements the method in this protocol.
 */
@protocol YYAsyncLayerDelegate <NSObject>
@required
/// This method is called to return a new display task when the layer's contents need update.
- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask;
@end


/**
 A display task used by YYAsyncLayer to render the contents in background queue.
 */
@interface YYAsyncLayerDisplayTask : NSObject

/**
 This block is called to draw the layer's contents.
 
 @discussion This block may be called on main thread or background thread,
 so is should be thread-safe.
 
 block param context:      A new bitmap content created by layer.
 block param size:         The content size (typically same as layer's bound size).
 block param isCancelled:  If this block returns `YES`, the method should cancel the
   drawing process and return as quickly as possible.
 */
@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

@end

NS_ASSUME_NONNULL_END
