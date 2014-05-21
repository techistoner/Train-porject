//
//  UIView+TECHRemoveAnimated.m
//  Train-special
//
//  Created by mac  on 14-4-15.
//  Copyright (c) 2014年 GST_MAC02. All rights reserved.
//

#import "UIView+TECHRemoveAnimated.h"

@implementation UIView (TECHRemoveAnimated)
// remove static analyser warnings
#ifndef __clang_analyzer__

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
   if ([animationID isEqualToString:@"fadeout"]) {
       // Restore the opacity
        CGFloat originalOpacity = [(NSNumber *)context floatValue];
     self.layer.opacity = originalOpacity;
        [self removeFromSuperview];
       [(NSNumber *)context release];
      }
}
- (void)removeFromSuperviewAnimated {
   [UIView beginAnimations:@"fadeout" context:[[NSNumber numberWithFloat:self.layer.opacity] retain]];
   [UIView setAnimationDuration:0.3];
   [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
   [UIView setAnimationDelegate:self];
   self.layer.opacity = 0;
   [UIView commitAnimations];
}
#endif
@end
