//
//  GrpahModel.h
//  GraphController
//
//  Created by SSF on 04.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface GrpahModel : NSObject

@property (readonly) CGRect graphRct;
@property (readonly) CGFloat ratios;
//for test
@property (nonatomic) double minSize;


@property (nonatomic,strong) NSNumber* zeroPointX;
@property (nonatomic,strong) NSNumber* zeroPointY;
//points arrays in screen coordinates
@property (nonatomic,readonly) NSArray* firstLevelXPoints;
@property (nonatomic,readonly) NSArray* firstLevelYPoints;
@property (nonatomic,readonly) NSArray* secondLevelXPoints;
@property (nonatomic,readonly) NSArray* secondLevelYPoints;
@property (nonatomic,readonly) NSArray* thirdLevelXPoints;
@property (nonatomic,readonly) NSArray* thirdLevelYPoints;

@property (nonatomic,readonly) NSArray* markXPoints;
@property (nonatomic,readonly) NSArray* markYPoints;


//set new graph rect or/and screen rect
-(void)changeGraphRect:(CGRect)graphRect forScreen:(CGRect)screenRect;

@end
