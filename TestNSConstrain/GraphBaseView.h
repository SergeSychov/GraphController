//
//  GraphBaseView.h
//  GraphController
//
//  Created by SSF on 01.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import <UIKit/UIKit.h>
//gaph base

@interface GraphBaseView : UIView

@property (nonatomic) NSArray* firstXPoints;
@property (nonatomic) NSArray* firstYPoints;
@property (nonatomic) NSArray* secondXPoints;
@property (nonatomic) NSArray* secondYPoints;
@property (nonatomic) NSArray* thirdXPoints;
@property (nonatomic) NSArray* thirdYPoints;

@property (nonatomic) NSArray* markXPoints;
@property (nonatomic) NSArray* markYPoints;

@property (nonatomic) NSNumber* zeroPointX;
@property (nonatomic) NSNumber* zeroPointY;

@property (nonatomic) NSArray* graphsArrays;

@end
