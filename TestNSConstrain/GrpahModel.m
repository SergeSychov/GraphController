//
//  GrpahModel.m
//  GraphController
//
//  Created by SSF on 04.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import "GrpahModel.h"

#define MIN_SIZE_IN_POINTS 6.5f

@interface GrpahModel()
@property (nonatomic) CGRect screenRect;
@property (nonatomic) CGRect graphRect;
@property (nonatomic,strong) NSNumber* zPointX;
@property (nonatomic,strong) NSNumber* zPointY;


@property (nonatomic) CGFloat ratio;

//points arrays in screen coordinates
@property (nonatomic) NSArray* firstXPoints;
@property (nonatomic) NSArray* firstYPoints;
@property (nonatomic) NSArray* secondXPoints;
@property (nonatomic) NSArray* secondYPoints;
@property (nonatomic) NSArray* thirdXPoints;
@property (nonatomic) NSArray* thirdYPoints;

//for description points real size for third level
@property (nonatomic) NSArray* markX;
@property (nonatomic) NSArray* markY;


@end

@implementation GrpahModel
#pragma mark CHANGE RECT
//Change graph rectange size
//input need graph area as recta
//setup output arrays for X and Y lines
//and ratio
-(void)changeGraphRect:(CGRect)graphRect forScreen:(CGRect)screenRect{
    //1. find proportional Rect for graph
    CGFloat xRatio = graphRect.size.width/screenRect.size.width;
    CGFloat yRatio = graphRect.size.height/screenRect.size.height;
    
    //find the bigest ratio and set its as actual ratio
    //set new Rect for graph - full screen
    if(xRatio > yRatio){
        _ratio = xRatio;
        
        CGFloat heightCoeff = xRatio/yRatio;
        graphRect.origin.y = graphRect.origin.y-(graphRect.size.height * (heightCoeff-1))/2;
        graphRect.size.height = graphRect.size.height * heightCoeff;
        
        
    } else{
        _ratio = yRatio;
        
        CGFloat widthtCoeff = yRatio/xRatio;
        graphRect.origin.x = graphRect.origin.x-(graphRect.size.width * (widthtCoeff-1))/2;
        graphRect.size.width = graphRect.size.width * widthtCoeff;
        
    }
    
    //set actual graph rects
    _screenRect = screenRect;
    _graphRect = graphRect;
    
    //define minimum line delta size
    //minimum size for screen in points equal 6.5
    double minSize = (double)_ratio * MIN_SIZE_IN_POINTS;
    //find discharge
    NSInteger discharge = (NSInteger)floor(log10(minSize));
    //make number one exp
    double expMinSize = minSize / pow(10, discharge);
    //find first digits
    double minSizeIntPart;
    double fractPart = modf(expMinSize, &minSizeIntPart);
    NSInteger minSizeInt = (NSInteger)minSizeIntPart;
    //find closest to 5 or 10
    while ((minSizeInt % 5)!=0) {
        minSizeInt++;
    }
    minSize = (double)minSizeInt*pow(10, (double)discharge);
    self.minSize = minSize;

    
    
    //find start x for line
    double startXOneValue = (double)_graphRect.origin.x;
    //make discharge as min delta
    double expStartXValue = startXOneValue / pow(10, (double)discharge);
    //find first digits
    double startValueXIntPart;
    double startValueFract = modf(expStartXValue, &startValueXIntPart);
    NSInteger startXValueInt = (NSInteger)startValueXIntPart;
    //find closest to min delta
    while ((startXValueInt %  minSizeInt)!=0) {
        startXValueInt++;
    }

    
    //the same for Y
    double startYValue = (double)_graphRect.origin.y;
    double expStartYValue = startYValue / pow(10, discharge);
    double startValueYIntPart;
    double startValueYFract = modf(expStartYValue, &startValueYIntPart);
    NSInteger startYValueInt = (NSInteger)startValueYIntPart;
    while ((startYValueInt %  minSizeInt)!=0) {
        startYValueInt++;
    }

    //set zero to nil
    self.zPointX = nil;
    self.zPointY = nil;
    
    
    @autoreleasepool {
        NSMutableArray *firstLevelPoint = [[NSMutableArray alloc]init];
        NSMutableArray *secondLevelPoint = [[NSMutableArray alloc]init];
        NSMutableArray *thirdLevelPoint = [[NSMutableArray alloc]init];
        NSMutableArray *markMutPoints = [[NSMutableArray alloc]init];


        //set arrays for X lines
        for(NSInteger currValue = startXValueInt;
            currValue <(_graphRect.origin.x+_graphRect.size.width)/pow(10.,discharge); currValue+=minSizeInt ){
            
            //find screen x coordinate
            double xCoord = (currValue*pow(10.,discharge)-_graphRect.origin.x)/_ratio;
            NSNumber* toArray = [NSNumber numberWithDouble:xCoord];
            //NSLog(@"curValue: %f, minSize: %f", currValue*pow(10.,discharge), minSize);
            
            if(currValue == 0.0){
                self.zPointX = toArray;
                
            } else if((currValue %(10*minSizeInt))==0){
                [thirdLevelPoint addObject:toArray];
                [markMutPoints addObject:[NSNumber numberWithDouble:currValue*pow(10.,discharge)]];

            } else if((currValue%(5*minSizeInt))==0) {
                [secondLevelPoint addObject:toArray];
                
            } else {
                [firstLevelPoint addObject:toArray];
            }
        }
        
        self.firstXPoints = [firstLevelPoint copy];
        [firstLevelPoint removeAllObjects];
        
        self.secondXPoints = [secondLevelPoint copy];
        [secondLevelPoint removeAllObjects];

        self.thirdXPoints = [thirdLevelPoint copy];
        [thirdLevelPoint removeAllObjects];
        
        self.markX = [markMutPoints copy];
        [markMutPoints removeAllObjects];

        
        //set arrays for Y lines
        for(NSInteger currValue = startYValueInt;
            currValue <(_graphRect.origin.y+_graphRect.size.height)/pow(10., discharge); currValue+=minSizeInt ){
            
            //find screen x coordinate
            double yCoord = _screenRect.size.height -(currValue*pow(10., discharge)-_graphRect.origin.y)/_ratio;
            NSNumber* toArray = [NSNumber numberWithDouble:yCoord];

            if(currValue == 0.0){
                self.zPointY = toArray;
                
            } else if((currValue%(10*minSizeInt))==0){
                [thirdLevelPoint addObject:toArray];
                [markMutPoints addObject:[NSNumber numberWithDouble:currValue*pow(10.,discharge)]];

            } else if((currValue%(5*minSizeInt))==0) {
                [secondLevelPoint addObject:toArray];
            } else {
                [firstLevelPoint addObject:toArray];
            }

        }
        
        //if no Zero set on side
        if(!self.zPointX){
            if(graphRect.origin.x > 0.){
                self.zPointX = [NSNumber numberWithDouble:0.0];
            } else if ((graphRect.origin.x + graphRect.size.width)<0){
                self.zPointX = [NSNumber numberWithFloat:screenRect.size.width];
            }
        }
        
        if(!self.zPointY){
            if(graphRect.origin.y > 0.){
                self.zPointY = [NSNumber numberWithFloat:screenRect.size.height];
            } else if ((graphRect.origin.y + graphRect.size.height)<0){
                self.zPointY = [NSNumber numberWithFloat:0.0];
            }
        }

        
        self.firstYPoints = [firstLevelPoint copy];
        self.secondYPoints = [secondLevelPoint copy];
        self.thirdYPoints = [thirdLevelPoint copy];
        self.markY = [markMutPoints copy];
    }
    
}

/*
-(CGRect)setNewGraphRectFrom:(CGRect)rct withRatio:(CGFloat)ratio{
    
    CGRect retRect = rct;
    
    //width
    
    
    return retRect;
}
*/
#pragma mark SETUP
-(void)setup{
     self.firstXPoints = [[NSArray alloc] init];
     self.firstYPoints= [[NSArray alloc] init];
     self.secondXPoints= [[NSArray alloc] init];
     self.secondYPoints= [[NSArray alloc] init];
     self.thirdXPoints= [[NSArray alloc] init];
     self.thirdYPoints= [[NSArray alloc] init];
    self.markX = [[NSArray alloc] init];
    self.markY = [[NSArray alloc] init];

}

-(id) init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

#pragma READ 
-(CGFloat)ratios{
    return (CGFloat)self.ratio;
}

-(CGRect)graphRct{
    return self.graphRect;
}

-(NSNumber*)zeroPointX{
    return self.zPointX;
}

-(NSNumber*)zeroPointY{
    return self.zPointY;
}

-(NSArray*)firstLevelXPoints{
    return self.firstXPoints;
}
-(NSArray*)firstLevelYPoints{
    return self.firstYPoints;
}
-(NSArray*)secondLevelXPoints{
    return self.secondXPoints;
}
-(NSArray*)secondLevelYPoints{
    return self.secondYPoints;
}
-(NSArray*)thirdLevelXPoints{
    return self.thirdXPoints;
}
-(NSArray*)thirdLevelYPoints{
    return self.thirdYPoints;
}

-(NSArray*)markXPoints{
    return self.markX;
}
-(NSArray*)markYPoints{
    return self.markY;
}

@end
