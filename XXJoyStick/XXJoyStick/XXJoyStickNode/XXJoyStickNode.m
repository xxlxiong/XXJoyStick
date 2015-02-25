//
//  XXJoyStickNode.m
//  XXJoyStick
//
//  Created by XXL on 2/25/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import "XXJoyStickNode.h"

@implementation XXJoyStickNode

+(instancetype)getJoyStickNodeWithSize:(CGSize)size
{
    static dispatch_once_t stick_one;
    static XXJoyStickNode *stickNode = nil;
    dispatch_once(&stick_one, ^{
        stickNode = [[XXJoyStickNode alloc] initWithSize:size];
    });
    return stickNode;
}

+ (instancetype)getJoyStickNode
{
    return [self getJoyStickNodeWithSize:CGSizeMake(128, 128)];
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super init]) {
        SKTexture *bkTexture = [SKTexture textureWithImageNamed:@"dpad.png"];
        SKTexture *jkTexture = [SKTexture textureWithImageNamed:@"joystick.png"];
        backgroundNode = [SKSpriteNode spriteNodeWithTexture:bkTexture size:size];
        joyStickNode = [SKSpriteNode spriteNodeWithTexture:jkTexture size:CGSizeMake(size.width/2, size.height/2)];
        
        [self addChild:backgroundNode];
        [self addChild:joyStickNode];
        
        _stickDirection = JK_NONE;
        _size = size;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    if ([joyStickNode containsPoint:point]) {
        return;
    }
    _direct = CGVectorMake(point.x, point.y);
    if([_delegate respondsToSelector:@selector(directionChange:oldDirect:newDirection:)])
    {
        [_delegate directionChange:self oldDirect:CGVectorMake(0, 0) newDirection:_direct];
    }
    
    enum JoyStickDirection _direction = [self changeVector2Direction:_direct];
    //改变很大,改变了大致方位
    if (_direction != _stickDirection) {
        _stickDirection = _direction;
        
        if([_delegate respondsToSelector:@selector(directionChangeBig:oldDirect:newDirection:)])
            [_delegate directionChangeBig:self oldDirect:CGVectorMake(0, 0) newDirection:_direct];
    }
    _moveDistance = MIN(_size.width/4, _size.height/4);
    [self stickMove:_direct distance:MIN(_size.width/4, _size.height/4)];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    
    _direct = CGVectorMake(point.x, point.y);
    
    //方位变化(细微检测)
    if([_delegate respondsToSelector:@selector(directionChange:oldDirect:newDirection:)])
    {
        [_delegate directionChange:self oldDirect:CGVectorMake(0, 0) newDirection:_direct];
    }
    
    enum JoyStickDirection _direction = [self changeVector2Direction:_direct];
    //改变很大,改变了大致方位
    if (_direction != _stickDirection) {
        _stickDirection = _direction;
        
        if([_delegate respondsToSelector:@selector(directionChangeBig:oldDirect:newDirection:)])
            [_delegate directionChangeBig:self oldDirect:CGVectorMake(0, 0) newDirection:_direct];
    }
    _moveDistance = MIN(hypotf(point.x,point.y), MIN(_size.width/4, _size.height/4));
    [self stickMove:_direct distance:_moveDistance];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //没有方向就不必再计算
    if (_stickDirection == JK_NONE) {
        return;
    }
    
    if([_delegate respondsToSelector:@selector(touchEnd:oldDirect:)])
        [_delegate touchEnd:self oldDirect:_direct];
    
    _stickDirection = JK_NONE;
    _direct = CGVectorMake(0, 0);
    _moveDistance = 0;
    //原点回到原味
    [self stickMove:_direct distance:0];
}

- (enum JoyStickDirection)changeVector2Direction:(CGVector)vector
{
    float tanAngle = _direct.dy/_direct.dx;
    if (_direct.dx >0 && fabsf(tanAngle)<=1) {
        return JK_RIGHT;
    }
    else if (_direct.dx<0 && fabsf(tanAngle)<=1)
        return JK_LEFT;
    else if (_direct.dy>0 && fabsf(tanAngle)>1)
        return JK_UP;
    else if (_direct.dy<0 && fabsf(tanAngle)>1)
        return JK_BOTTOM;
    else
        return JK_NONE;
}

//move stick to direct
- (void)stickMove:(CGVector)direct distance:(float)distance
{
    CGPoint postion = CGPointZero;
    if (direct.dx || direct.dy) {
        float sin = direct.dx/hypotf(direct.dx, direct.dy);
        float cos = direct.dy/hypotf(direct.dx, direct.dy);
        
        postion.x = sin*distance;
        postion.y = cos*distance;
    }
    
    joyStickNode.position = postion;
}
@end
