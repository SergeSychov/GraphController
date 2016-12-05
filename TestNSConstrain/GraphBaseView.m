//
//  GraphBaseView.m
//  GraphController
//
//  Created by SSF on 01.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import "GraphBaseView.h"
#define FIRST_RISK_LENGHT 2.f
#define SECOND_RISK_LENGHT 3.f
#define THIRD_RISK_LENGHT 4.5f




@interface GraphBaseView() <CAAnimationDelegate>

@end

@implementation GraphBaseView


#pragma mark SETUP
-(void) setup{
    self.firstXPoints = [[NSArray alloc]init];
    self.firstYPoints = [[NSArray alloc]init];
    self.secondXPoints= [[NSArray alloc]init];
    self.secondYPoints= [[NSArray alloc]init];
    self.thirdXPoints = [[NSArray alloc]init];
    self.thirdYPoints = [[NSArray alloc]init];
    self.markXPoints = [[NSArray alloc]init];
    self.markYPoints = [[NSArray alloc]init];

    
    self.graphsArrays = [[NSArray alloc]init];
    self.zeroPointY = nil;
    self.zeroPointX = nil;
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    
    return self;
}

#pragma mark DRAW LINES
-(void) drawLinesWithContect:(CGContextRef)contex inRect:(CGRect)rect{
    
    //collors
    UIColor *calcColor = [UIColor colorWithRed:.259
                                         green:.569
                                          blue:.702
                                         alpha:.25];
    
    UIColor *axisColor = [UIColor colorWithRed:.500
                                         green:.500
                                          blue:.500
                                         alpha:1.];
    /*
    UIColor *axisColor = [UIColor colorWithRed:.847
                                         green:.616
                                          blue:.051
                                         alpha:1.];
    */
    
    UIBezierPath *axisPath = [UIBezierPath bezierPath];
    CGPathRef axisCGPath;
    
    
    CGFloat lineThin = 1.5;
    CGFloat xZero = 0;
    CGFloat yZero = 0;
    if(self.zeroPointX){
        xZero = (CGFloat)[self.zeroPointX doubleValue];
        if(xZero <= lineThin){
            xZero=lineThin/2;
        } else if(xZero >= (rect.size.width-lineThin)){
            xZero=rect.size.width-lineThin/2;
        }
        [axisPath moveToPoint:CGPointMake(xZero, 0)];
        [axisPath addLineToPoint:CGPointMake(xZero, rect.size.height)];
        //make arrow
        CGPoint startPoint = CGPointMake(xZero, 0);
        CGPoint secondPoint = CGPointMake(startPoint.x+1.5*THIRD_RISK_LENGHT, startPoint.y+13.);
        CGPoint thirdPoint = CGPointMake(startPoint.x-1.5*THIRD_RISK_LENGHT, startPoint.y+13.);
        CGPoint arcPoint = CGPointMake(startPoint.x, startPoint.y+10.);

        [axisPath moveToPoint:secondPoint];
        [axisPath addLineToPoint:startPoint];
        [axisPath addLineToPoint:thirdPoint];
        
    }
    if(self.zeroPointY){
        yZero = (CGFloat)[self.zeroPointY doubleValue];
        if(yZero <= lineThin){
            yZero=lineThin/2;
        } else if(yZero >= rect.size.height-lineThin){
            yZero=rect.size.height-lineThin/2;
        }
        
        CGPoint startPoint = CGPointMake(rect.size.width, yZero);
        [axisPath moveToPoint:CGPointMake(0, yZero)];
        [axisPath addLineToPoint:CGPointMake(rect.size.height, yZero)];
        
        //make arrow
        CGPoint secondPoint = CGPointMake(startPoint.x-13, startPoint.y-1.5*THIRD_RISK_LENGHT);
        CGPoint thirdPoint = CGPointMake(startPoint.x-13, startPoint.y+1.5*THIRD_RISK_LENGHT);
        CGPoint arcPoint = CGPointMake(startPoint.x-10, startPoint.y);
        /*
        [axisPath moveToPoint:startPoint];
        [axisPath addLineToPoint:secondPoint];
        [axisPath addCurveToPoint:thirdPoint controlPoint1:arcPoint controlPoint2:arcPoint];
        [axisPath addLineToPoint:startPoint];
        */
        [axisPath moveToPoint:secondPoint];
        [axisPath addLineToPoint:startPoint];
        [axisPath addLineToPoint:thirdPoint];
    }
    
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, axisColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    
    axisCGPath = axisPath.CGPath;
    CGContextAddPath(contex, axisCGPath);
    CGContextDrawPath(contex, kCGPathStroke);
    
    
    
    
    UIBezierPath *patch = [UIBezierPath bezierPath];
    CGPathRef pathOfRect;
    //draw first level lines
    //X
    lineThin = 0.5;
    if([self.firstXPoints count]>0){
        for(NSNumber *xPointNum in self.firstXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [patch moveToPoint:CGPointMake(xPointFloat, 0)];
            [patch addLineToPoint:CGPointMake(xPointFloat, rect.size.height)];
        }
    }
    if([self.firstYPoints count]>0){
        for(NSNumber *yPointNum in self.firstYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [patch moveToPoint:CGPointMake(0, yPointFloat)];
            [patch addLineToPoint:CGPointMake(rect.size.width, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, calcColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    pathOfRect = patch.CGPath;
    CGContextAddPath(contex, pathOfRect);
    CGContextDrawPath(contex, kCGPathStroke);
    
    //draw black riscs
    UIBezierPath *riscsPatch = [UIBezierPath bezierPath];
    CGPathRef pathOfRiscst;
    lineThin = 0.5;
    if([self.firstXPoints count]>0){
        for(NSNumber *xPointNum in self.firstXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [riscsPatch moveToPoint:CGPointMake(xPointFloat, yZero-FIRST_RISK_LENGHT )];
            [riscsPatch addLineToPoint:CGPointMake(xPointFloat, yZero+FIRST_RISK_LENGHT )];
        }
    }
    if([self.firstYPoints count]>0){
        for(NSNumber *yPointNum in self.firstYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [riscsPatch moveToPoint:CGPointMake(xZero-FIRST_RISK_LENGHT, yPointFloat)];
            [riscsPatch addLineToPoint:CGPointMake(xZero+FIRST_RISK_LENGHT, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, axisColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    pathOfRiscst = riscsPatch.CGPath;
    CGContextAddPath(contex, pathOfRiscst);
    CGContextDrawPath(contex, kCGPathStroke);

    

    UIBezierPath *secondPatch = [UIBezierPath bezierPath];
    CGPathRef secondpathOfRect;
    lineThin = 1.;
    if([self.secondXPoints count]>0){
        for(NSNumber *xPointNum in self.secondXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [secondPatch moveToPoint:CGPointMake(xPointFloat, 0)];
            [secondPatch addLineToPoint:CGPointMake(xPointFloat, rect.size.height)];
        }
    }
    if([self.secondYPoints count]>0){
        for(NSNumber *yPointNum in self.secondYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [secondPatch moveToPoint:CGPointMake(0, yPointFloat)];
            [secondPatch addLineToPoint:CGPointMake(rect.size.width, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, calcColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    secondpathOfRect = secondPatch.CGPath;
    CGContextAddPath(contex, secondpathOfRect);
    CGContextDrawPath(contex, kCGPathStroke);

    //draw black riscs
    UIBezierPath *riscsSecPatch = [UIBezierPath bezierPath];
    CGPathRef pathOfRiscsSec;
    if([self.secondXPoints count]>0){
        for(NSNumber *xPointNum in self.secondXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [riscsSecPatch moveToPoint:CGPointMake(xPointFloat, yZero-SECOND_RISK_LENGHT )];
            [riscsSecPatch addLineToPoint:CGPointMake(xPointFloat, yZero+SECOND_RISK_LENGHT )];
        }
    }
    if([self.secondYPoints count]>0){
        for(NSNumber *yPointNum in self.secondYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [riscsSecPatch moveToPoint:CGPointMake(xZero-SECOND_RISK_LENGHT, yPointFloat)];
            [riscsSecPatch addLineToPoint:CGPointMake(xZero+SECOND_RISK_LENGHT, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, axisColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    pathOfRiscsSec = riscsSecPatch.CGPath;
    CGContextAddPath(contex, pathOfRiscsSec);
    CGContextDrawPath(contex, kCGPathStroke);
    
    UIBezierPath *thirdPatch = [UIBezierPath bezierPath];
    CGPathRef thirdPathOfRect;
    lineThin = 1.5;
    if([self.thirdXPoints count]>0){
        for(NSNumber *xPointNum in self.thirdXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [thirdPatch moveToPoint:CGPointMake(xPointFloat, 0)];
            [thirdPatch addLineToPoint:CGPointMake(xPointFloat, rect.size.height)];
        }
    }
    if([self.thirdYPoints count]>0){
        for(NSNumber *yPointNum in self.thirdYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [thirdPatch moveToPoint:CGPointMake(0, yPointFloat)];
            [thirdPatch addLineToPoint:CGPointMake(rect.size.width, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, calcColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    thirdPathOfRect = thirdPatch.CGPath;
    CGContextAddPath(contex, thirdPathOfRect);
    CGContextDrawPath(contex, kCGPathStroke);
    
    //draw black riscs
    UIBezierPath *riscsThirdPatch = [UIBezierPath bezierPath];
    CGPathRef pathOfRiscsThird;
    if([self.thirdXPoints count]>0){
        for(NSNumber *xPointNum in self.thirdXPoints){
            CGFloat xPointFloat = (CGFloat)[xPointNum doubleValue];
            [riscsThirdPatch moveToPoint:CGPointMake(xPointFloat, yZero-THIRD_RISK_LENGHT )];
            [riscsThirdPatch addLineToPoint:CGPointMake(xPointFloat, yZero+THIRD_RISK_LENGHT )];
        }
    }
    if([self.thirdYPoints count]>0){
        for(NSNumber *yPointNum in self.thirdYPoints){
            CGFloat yPointFloat = (CGFloat)[yPointNum doubleValue];
            [riscsThirdPatch moveToPoint:CGPointMake(xZero-THIRD_RISK_LENGHT, yPointFloat)];
            [riscsThirdPatch addLineToPoint:CGPointMake(xZero+THIRD_RISK_LENGHT, yPointFloat)];
        }
    }
    CGContextSetLineWidth(contex, lineThin);
    CGContextSetStrokeColorWithColor(contex, axisColor.CGColor);
    CGContextSetLineCap(contex, kCGLineCapRound);
    pathOfRiscsThird = riscsThirdPatch.CGPath;
    CGContextAddPath(contex, pathOfRiscsThird);
    CGContextDrawPath(contex, kCGPathStroke);
    
    //draw marks
    //1 make strings arrays
    NSMutableArray *xPointString =[[NSMutableArray alloc]init];
    NSMutableArray *yPointString =[[NSMutableArray alloc]init];

    //1.1. X
    if([self.markXPoints count]>0){
        for(NSNumber *point in self.markXPoints){
            [xPointString addObject:[point descriptionWithLocale:[NSLocale currentLocale]]];
        }
    }
    
    if([self.markYPoints count]>0){
        for(NSNumber *point in self.markYPoints){
            [yPointString addObject:[point descriptionWithLocale:[NSLocale currentLocale]]];
        }
    }
    //NSLog(@"x points: %@,\n y points:%@",xPointString,yPointString);

   // NSString *mark = @"1000";
   // [mark drawWithRect:<#(CGRect)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLinesWithContect:context inRect:rect];
}


@end
