/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTDecayAnimation.h"

#import <UIKit/UIKit.h>

#import <React/RCTConvert.h>
#import <React/RCTDefines.h>

#import "RCTAnimationUtils.h"
#import "RCTValueAnimatedNode.h"
#import <math.h>


@interface RCTDecayAnimation ()

@property (nonatomic, strong) NSNumber *animationId;
@property (nonatomic, strong) RCTValueAnimatedNode *valueNode;
@property (nonatomic, assign) BOOL animationHasBegun;
@property (nonatomic, assign) BOOL animationHasFinished;

@end

@implementation RCTDecayAnimation
{
    CGFloat _toValue;
    CGFloat _fromValue;
    CGFloat _lastValue;
    
    double _velocity;
    double _deceleration;
    
    NSTimeInterval _animationStartTime;
    NSTimeInterval _animationCurrentTime;
    RCTResponseSenderBlock _callback;
}

- (instancetype)initWithId:(NSNumber *)animationId
                    config:(NSDictionary *)config
                   forNode:(RCTValueAnimatedNode *)valueNode
                  callBack:(nullable RCTResponseSenderBlock)callback;
{
    if ((self = [super init])) {
        NSNumber *toValue = [RCTConvert NSNumber:config[@"toValue"]] ?: @1;
        double velocity = [RCTConvert double:config[@"velocity"]];
        double deceleration = [RCTConvert double:config[@"deceleration"]];
        
        
        _animationId = animationId;
        _toValue = toValue.floatValue;
        
        _fromValue = valueNode.value;
        _lastValue = valueNode.value;
        _valueNode = valueNode;
        
        _velocity = velocity;
        _deceleration = deceleration;
        _callback = [callback copy];
    }
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (void)startAnimation
{
    _animationStartTime = CACurrentMediaTime();
    _animationCurrentTime = _animationStartTime;
    _animationHasBegun = YES;
}

- (void)stopAnimation
{
    _animationHasFinished = YES;
}

- (void)removeAnimation
{
    [self stopAnimation];
    _valueNode = nil;
    if (_callback) {
        _callback(@[@{
                        @"finished": @(_animationHasFinished)
                        }]);
    }
}

- (void)stepAnimation
{
    if (!_animationHasBegun || _animationHasFinished) {
        // Animation has not begun or animation has already finished.
        return;
    }
    
    
    NSTimeInterval currentTime = CACurrentMediaTime();
    _animationCurrentTime = currentTime;
    NSTimeInterval currentDuration = (_animationCurrentTime - _animationStartTime) * 1000;
    
    
    CGFloat value = _fromValue + (_velocity / (1 - _deceleration)) * (1 - exp(-1 * (1 - _deceleration) * currentDuration));
    
    
    if (fabsf((_lastValue - value)) < 0.1) {
        _animationHasFinished = YES;
    }
    
    [self onUpdate:value];
    _lastValue = value;
}

- (void)onUpdate:(CGFloat)outputValue
{
    _valueNode.value = outputValue;
    [_valueNode setNeedsUpdate];
}

@end
