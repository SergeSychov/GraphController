//
//  ChooseLinesView.m
//  GraphController
//
//  Created by SSF on 24.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import "ChooseLinesView.h"

@implementation ChooseLinesView
-(void) drawLinesWithContect:(CGContextRef)contex inRect:(CGRect)rect{
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat lineThin = 2.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x-lineThin, center.y-lineThin, lineThin*2, lineThin*2)];
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(0, center.y)];
    
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(rect.size.width, center.y)];
    
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(center.x, 0)];
    
    [path moveToPoint:center];
    [path addLineToPoint:CGPointMake(center.x, rect.size.height)];
    

    UIColor *rColor = [UIColor colorWithRed:.688
                                      green:.273
                                       blue:.355
                                      alpha:1.];
    
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, rColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    CGContextAddPath(contex, path.CGPath);
    CGContextDrawPath(contex, kCGPathFillStroke);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLinesWithContect:context inRect:rect];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
