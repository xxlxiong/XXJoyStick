//
//  GameScene.m
//  XXJoyStick
//
//  Created by XXL on 2/25/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    XXJoyStickNode *node = [XXJoyStickNode getJoyStickNode];
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame));
    node.delegate = self;
    [self addChild:node];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)directionChangeBig:(XXJoyStickNode*)joyStickNode oldDirect:(CGVector)oldDirect newDirection:(CGVector)newDirection
{
    NSLog(@"%d",joyStickNode.stickDirection);
}

@end
