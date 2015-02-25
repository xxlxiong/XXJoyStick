//
//  XXJoyStickNode.h
//  XXJoyStick
//
//  Created by XXL on 2/25/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class XXJoyStickNode;

enum JoyStickDirection
{
    JK_NONE,
    JK_LEFT,
    JK_RIGHT,
    JK_UP,
    JK_BOTTOM
};

@protocol JoyStickDelegate <NSObject>

@optional
//direction change
- (void)directionChangeBig:(XXJoyStickNode*)joyStickNode oldDirect:(CGVector)oldDirect newDirection:(CGVector)newDirection;

- (void)directionChange:(XXJoyStickNode*)joyStickNode oldDirect:(CGVector)oldDirect newDirection:(CGVector)newDirection;

- (void)touchEnd:(XXJoyStickNode*)joyStickNode oldDirect:(CGVector)oldDirect;

@end

@interface XXJoyStickNode : SKNode
{
    SKSpriteNode *backgroundNode;
    SKSpriteNode *joyStickNode;
    
    CGSize _size;
}

@property (nonatomic, assign) id<JoyStickDelegate> delegate;

@property (nonatomic,readonly) CGVector direct;
@property (nonatomic,readonly) float moveDistance;

@property (nonatomic,readwrite) enum JoyStickDirection stickDirection;
- (id)initWithSize:(CGSize)size;

+ (instancetype)getJoyStickNode;
+ (instancetype)getJoyStickNodeWithSize:(CGSize)size;

@end
