//
//  usersLinesView.m
//  GraphController
//
//  Created by SSF on 21.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import "UsersLinesView.h"

@interface UsersLinesView()

@property (nonatomic) BOOL startDraw;

@end

@implementation UsersLinesView

-(void)drawNeedLayerWithContect:(CGContextRef)context inRect:(CGRect)rect{
    if(self.startDraw){
        CGFloat radius;
        if(rect.size.width >= rect.size.height){
            radius = rect.size.height/2;
        }else{
            radius = rect.size.width/2;
        }
        
        //line with according size
        CGFloat lineWidth =radius/1.2;
        
        UIBezierPath *circlePatch = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth/2, lineWidth/2, 2*radius - lineWidth, 2*radius-lineWidth)];
        
        //color and opacity
        //if 2*radius = 65. - alpha 1;
        //if 2*radius > 2*screen.bigest - alpha = 0;
        CGFloat bigest ;
        if( self.window.screen.bounds.size.width >= self.window.screen.bounds.size.height){
            bigest = self.window.screen.bounds.size.width;
        } else {
           bigest = self.window.screen.bounds.size.height;
        }
        
        UIColor *circleColor = [UIColor colorWithRed:.847
                                             green:.300
                                              blue:.300
                                             alpha:0.5];
        
        

        CGContextSetLineWidth(context, lineWidth) ;
        CGContextSetStrokeColorWithColor(context, circleColor.CGColor);
        
        CGContextAddPath(context, circlePatch.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
        
        self.startDraw = NO;
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawNeedLayerWithContect:context inRect:rect];
}

#pragma mark INIT
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.startDraw = YES;
        
        
    }
    return self;
}

@end
