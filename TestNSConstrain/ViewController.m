//
//  ViewController.m
//  TestNSConstrain
//
//  Created by SSF on 30.11.16.
//  Copyright © 2016 SSF. All rights reserved.
//

#import "ViewController.h"
#import "GraphBaseView.h"
#import "GrpahModel.h"
#import "UsersLinesView.h"
#import "ChooseLinesView.h"


@interface ViewController ()

//layout constrains
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutLabelsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutButtonsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingZoomsView;

//gesture
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;

@property (weak, nonatomic) IBOutlet GraphBaseView *grpahBaseView;
@property (strong, nonatomic) GrpahModel *graphModel;
@property (nonatomic) CGRect graphRect;


@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *labelsView;
@property (weak, nonatomic) IBOutlet UIView *zoomButtonsView;

//@property (weak, nonatomic) IBOutlet UIView *backgroundLabelView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *usersCoordinateLabel;
@property (weak,nonatomic) UsersLinesView *showTouchView;
@property (weak, nonatomic) ChooseLinesView* choosLinesView;



@end

@implementation ViewController

#pragma mark SET RECT
-(void) setGraphRect:(CGRect)graphRect{
    _graphRect = graphRect;
    [self.graphModel changeGraphRect:_graphRect forScreen:self.view.bounds];
    
    _graphRect = self.graphModel.graphRct;
    
    self.grpahBaseView.firstXPoints = self.graphModel.firstLevelXPoints;
    self.grpahBaseView.firstYPoints = self.graphModel.firstLevelYPoints ;
    self.grpahBaseView.secondXPoints = self.graphModel.secondLevelXPoints;
    self.grpahBaseView.secondYPoints = self.graphModel.secondLevelYPoints;
    self.grpahBaseView.thirdXPoints = self.graphModel.thirdLevelXPoints;
    self.grpahBaseView.thirdYPoints = self.graphModel.thirdLevelYPoints;
    self.grpahBaseView.markXPoints = self.graphModel.markXPoints;
    self.grpahBaseView.markYPoints = self.graphModel.markYPoints;
    
    
    self.grpahBaseView.zeroPointX = self.graphModel.zeroPointX;
    self.grpahBaseView.zeroPointY = self.graphModel.zeroPointY;
    
    
    [self.grpahBaseView setNeedsDisplay];
    self.infoLabel.text = [NSString stringWithFormat:@"Rect: %f, %f, %f, %f \nRatio: %f \nPoinSize: %f",graphRect.origin.x, graphRect.origin.y, graphRect.size.width, graphRect.size.height, self.graphModel.ratios, self.graphModel.minSize];
    
    //self.label.text = @"hello world!";
    
}

-(void)newRectScale:(CGFloat)scale inPoint:(CGPoint)point{
    CGRect rct = self.graphRect;
    //scale
    rct.size.width = rct.size.width/scale;
    rct.size.height = rct.size.height/scale;
    
    //distans in graph rect according screen point
    CGSize distance;
    //1. convert into graph points
    distance.width = point.x*self.graphModel.ratios;
    distance.height = (self.grpahBaseView.bounds.size.height- point.y)*self.graphModel.ratios;
    
    //2.find new origin
    rct.origin.x = rct.origin.x+distance.width*(scale-1);
    rct.origin.y = rct.origin.y+distance.height*(scale-1);
    
    
    
    self.graphRect = rct;
}

-(void)newRectPoint:(CGPoint)point{
    CGRect rct = self.graphRect;
    rct.origin.x = rct.origin.x - point.x*self.graphModel.ratios;
    rct.origin.y = rct.origin.y - point.y*self.graphModel.ratios;
    
    self.graphRect = rct;
    
}

#pragma mark GESTURES
CGFloat lastScale;
CGPoint lastPoint;
BOOL shoodPan = NO;

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}


static BOOL isNeedUsersLineView;

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
        //NSLog(@"Need stop animation");
        if(!isNeedUsersLineView){
            [self removeChooseLineViewAnimate];
        }
        isNeedUsersLineView = NO;
        [self showButtonViewAnimate];
        [self showLabelsViewAnimate];
        [self showZoomViewAnimate];

    }
    else if(sender.state == UIGestureRecognizerStateBegan){
        isNeedUsersLineView = NO; //only start users line draw - not shure
        [self appearChooseLineViewinPoint:[sender locationInView:self.grpahBaseView]];
        
        [self hideButtonViewAnimate];
        [self hideZoomViewAnimate];

        
        
        //in case if its like pan
        lastPoint = [sender locationInView:self.view];
    } else if (sender.state == UIGestureRecognizerStateChanged){
        
        if(isNeedUsersLineView){
            
            //find new point for x according brain
            //IMPORTANT TEST need real func
            
            CGPoint countedPoint =[sender locationInView:self.grpahBaseView];
            countedPoint.y = countedPoint.x*2;
            [self moveChooseLineViewToPoint:countedPoint];
            
        } else {
            
            [self removeChooseLineViewAnimate];
            [self hideLabelsViewAnimate];

            
            CGPoint deltaPoint = lastPoint;
            CGPoint currPan = [sender locationInView:self.view];
            deltaPoint.x = currPan.x - lastPoint.x;
            deltaPoint.y = lastPoint.y - currPan.y;//to tranlate IOS cord
            lastPoint = currPan;
            [self newRectPoint:deltaPoint];
        }
        
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [self removeChooseLineViewAnimate];
        [self hideButtonViewAnimate];
        [self hideLabelsViewAnimate];
        [self hideZoomViewAnimate];
        lastPoint = [sender locationInView:self.view];
    } else if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint deltaPoint = lastPoint;
        CGPoint currPan = [sender locationInView:self.view];
        deltaPoint.x = currPan.x - lastPoint.x;
        deltaPoint.y = lastPoint.y - currPan.y;//to tranlate IOS cord
        lastPoint = currPan;
        [self newRectPoint:deltaPoint];
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        //[self showLabelAnimate];
        [self showButtonViewAnimate];
        [self showLabelsViewAnimate];
        [self showZoomViewAnimate];

    }else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
        [self showButtonViewAnimate];
        [self showLabelsViewAnimate];
        [self showZoomViewAnimate];
        // NSLog(@"filed or canceled");
    }
    
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    
    CGPoint currentGestureLocation = [sender locationInView:self.view];
    //NSLog(@"CurrPoint: %f, %f", currentGestureLocation.x, currentGestureLocation.y);
    double min = 1e-7;
    if(sender.state == UIGestureRecognizerStateBegan){
        [self removeChooseLineViewAnimate];
        
        [self hideButtonViewAnimate];
        [self hideLabelsViewAnimate];
        [self hideZoomViewAnimate];
        
        if(self.graphModel.ratios>min){
            lastScale = sender.scale;
            [self newRectScale:lastScale inPoint:currentGestureLocation];
        }else{
            lastScale = min;
            [self newRectScale:lastScale inPoint:currentGestureLocation];
            
        }
    } else if (sender.state == UIGestureRecognizerStateChanged){
        lastScale = sender.scale;
        if(self.graphModel.ratios>min){
            [self newRectScale:lastScale inPoint:currentGestureLocation];
            sender.scale = 1.;
        }else{
            lastScale = min;
            [self newRectScale:lastScale inPoint:currentGestureLocation];
            
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        if(self.graphModel.ratios>min){
            lastScale = sender.scale;
            [self newRectScale:lastScale inPoint:currentGestureLocation];
        }else{
            lastScale = min;
            [self newRectScale:lastScale inPoint:currentGestureLocation];
            
        }
        
        [self showButtonViewAnimate];
        [self showLabelsViewAnimate];
        [self showZoomViewAnimate];
        
    }else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
        // NSLog(@"filed or canceled");
        [self showButtonViewAnimate];
        [self showLabelsViewAnimate];
        [self showZoomViewAnimate];
    }
    //NSLog(@"CURR Scale: %f", lastScale);
    
}
#pragma mark ANIMATION
-(void)hideButtonViewAnimate{
    CGFloat newBottomLayout = -(self.buttonsView.bounds.size.height + 8.);
    self.bottomLayoutButtonsView.constant = newBottomLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}


-(void)showButtonViewAnimate{
    CGFloat newBottomLayout = 8.;
    self.bottomLayoutButtonsView.constant = newBottomLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         nil;
                     }];
}


-(void)hideLabelsViewAnimate{
    CGFloat newTopLayout = -(self.labelsView.bounds.size.height + 28.);
    self.topLayoutLabelsView.constant = newTopLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

-(void)showLabelsViewAnimate{
    CGFloat newTopLayout =8.;
    self.topLayoutLabelsView.constant = newTopLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

-(void)hideZoomViewAnimate{
    CGFloat newTrailingLayout = (self.zoomButtonsView.bounds.size.width + 28.);
    self.trailingZoomsView.constant = newTrailingLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}

-(void)showZoomViewAnimate{
    CGFloat newTrailingLayout =8.;
    self.trailingZoomsView.constant = newTrailingLayout;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }];
}


-(void)removeChooseLineViewAnimate{
    if(self.choosLinesView){
        [UIView animateWithDuration:1.2
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.choosLinesView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self.choosLinesView removeFromSuperview];
                             self.choosLinesView = nil;
                             isNeedUsersLineView = NO;
                             
                             [UIView animateWithDuration:0.2
                                                   delay:0
                                  usingSpringWithDamping:0.8
                                   initialSpringVelocity:0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.usersCoordinateLabel.hidden = YES;
                                              } completion:^(BOOL finished) {
                                                  nil;
                                              }];
                             //set initial text of label
                             self.usersCoordinateLabel.text = @"";
                         }];
    }
}


-(void)appearChooseLineViewinPoint:(CGPoint)point{
    //find initial big frame
    CGPoint centr = point;
    CGFloat bigestX = centr.x;
    CGFloat bigestY = centr.y;
    
    if(centr.x < (self.grpahBaseView.bounds.size.width- centr.x)){
        bigestX = (self.grpahBaseView.bounds.size.width- centr.x);
    }
    if(centr.y < (self.grpahBaseView.bounds.size.height - centr.y)){
        bigestY = (self.grpahBaseView.bounds.size.height - centr.y);
    }
    CGFloat bigestSide = bigestX;
    if(bigestY > bigestY){
        bigestSide = bigestY;
    }
    
    UsersLinesView *showTouchView = [[UsersLinesView alloc] initWithFrame:CGRectMake(0, 0, 65., 65.)];
    [showTouchView setCenter:point];
    [self.grpahBaseView addSubview:showTouchView];
    self.showTouchView = showTouchView;
    
    CGRect newRect = CGRectMake(0, 0, 3*bigestSide, 3*bigestSide);
    
    //isNeedUsersLineView = YES;//waiting for choose lines view
    
    
    //chow touches
    [UIView animateWithDuration:1.2
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0                            options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [showTouchView setBounds:newRect];
                         self.showTouchView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.showTouchView removeFromSuperview];
                         self.showTouchView = nil;
                     }];
    
    //set choose lines view
    //set center of chooseLines as counted point
    //IMPORTANT NEED COUNT
    CGPoint countedPoint = CGPointMake(centr.x, centr.x*2);
    
    //if Y coordinate over screen
    CGPoint visualCountedPoint = countedPoint;
    if(countedPoint.y > self.grpahBaseView.bounds.size.height){
        visualCountedPoint.y = self.grpahBaseView.bounds.size.height;
    } else if (countedPoint.y < 0){
        visualCountedPoint.y = 0;
    }
    
    if(!self.choosLinesView){
        //rect for choose lines view twice bigger then view frame
        CGRect chooseLinesViewRect = CGRectMake(0, 0, self.view.bounds.size.width*2, self.view.bounds.size.height*2);
        
        ChooseLinesView *chooseLinesView = [[ChooseLinesView alloc] initWithFrame:CGRectZero];//initial rect is ZERO - then animated rect
        
        
        chooseLinesView.center =  visualCountedPoint;
        [self.grpahBaseView addSubview:chooseLinesView];
        self.choosLinesView = chooseLinesView;
        
        //show lines with delay
        [UIView animateWithDuration:0.8
                              delay:0.3
             usingSpringWithDamping:0.9
              initialSpringVelocity:0                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [chooseLinesView setBounds:chooseLinesViewRect];
                             
                         } completion:^(BOOL finished) {
                             
                             //set additional text in label
                             //count point in graph rect coordinates
                             
                             CGFloat xInGrapphCoord = self.graphRect.origin.x+countedPoint.x*self.graphModel.ratios;
                             
                             CGFloat yInGrapphCoord = self.graphRect.origin.y+(self.grpahBaseView.bounds.size.height- countedPoint.y)*self.graphModel.ratios;
                             self.usersCoordinateLabel.text = [NSString stringWithFormat:@"\n X = %f, Y = %f", xInGrapphCoord, yInGrapphCoord];
                             [UIView animateWithDuration:0.2
                                                   delay:0
                                  usingSpringWithDamping:0.9
                                   initialSpringVelocity:0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.usersCoordinateLabel.hidden = NO;
                                                  [self.view layoutIfNeeded];
                                              } completion:^(BOOL finished) {
                                                  nil;
                                              }];
                             
                             isNeedUsersLineView = YES;
                             
                             
                         }];
    } else {
        [UIView animateWithDuration:0.8
                              delay:0.3
             usingSpringWithDamping:0.9
              initialSpringVelocity:0                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.choosLinesView  setCenter:visualCountedPoint];
                             
                         } completion:^(BOOL finished) {
                             
                             CGFloat xInGrapphCoord = self.graphRect.origin.x+countedPoint.x*self.graphModel.ratios;
                             
                             CGFloat yInGrapphCoord = self.graphRect.origin.y+(self.grpahBaseView.bounds.size.height- countedPoint.y)*self.graphModel.ratios;
                             self.usersCoordinateLabel.text = [NSString stringWithFormat:@"\n X = %f, Y = %f", xInGrapphCoord, yInGrapphCoord];
                             [UIView animateWithDuration:0.2
                                                   delay:0
                                  usingSpringWithDamping:0.8
                                   initialSpringVelocity:0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.usersCoordinateLabel.hidden = NO;
                                                   [self.view layoutIfNeeded];
                                              } completion:^(BOOL finished) {
                                                  nil;
                                              }];
                             
                             isNeedUsersLineView = YES;
                             
                         }];
    }
}

-(void)moveChooseLineViewToPoint:(CGPoint)point{
    
    CGPoint visualCountedPoint = point;
    if(point.y > self.grpahBaseView.bounds.size.height){
        visualCountedPoint.y = self.grpahBaseView.bounds.size.height;
    } else if (point.y < 0){
        visualCountedPoint.y = 0;
    }
    
    [self.choosLinesView  setCenter:visualCountedPoint];
    
    //set label value
    CGFloat xInGrapphCoord = self.graphRect.origin.x+point.x*self.graphModel.ratios;
    
    CGFloat yInGrapphCoord = self.graphRect.origin.y+(self.grpahBaseView.bounds.size.height- point.y)*self.graphModel.ratios;
    self.usersCoordinateLabel.text = [NSString stringWithFormat:@"\n X = %f, Y = %f", xInGrapphCoord, yInGrapphCoord];
    
}


#pragma mark OBSERV LABEL CHANGE
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.infoLabel && [keyPath isEqualToString:@"bounds"]) {
        
        NSLog(@"Bounds label was changed");
        CGRect rct = self.backgroundLabelView.frame;
        rct.origin.y += (rct.size.height-self.label.bounds.size.height)/2;
        rct.size.height = self.label.bounds.size.height;
        //rct.size.height = 100;
        //[self.backgroundLabelView setFrame:rct];;
        //[self.backgroundLabelView setNeedsUpdateConstraints];
        [self.backgroundLabelView setFrame:rct];
        [self.view setNeedsUpdateConstraints];
        // do your stuff, or better schedule to run later using performSelector:withObject:afterDuration:
    }
}
*/

#pragma mark VIEW_DID_LOAD
/*
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"");
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    GrpahModel *graphModel = [[GrpahModel alloc]init];
    self.graphModel = graphModel;
    
    self.graphRect = CGRectMake(-50., -50., 100., 100);
    
    
    //catch changing label
    //[self.infoLabel addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    //self.longPressRecognizer.delegate = self;
    //self.backgroundLabelView.bounds = self.label.bounds;
    self.longPressRecognizer.numberOfTapsRequired=0;
    
    self.usersCoordinateLabel.text = @"";
    self.usersCoordinateLabel.hidden = YES;
    
    self.bottomLayoutButtonsView.constant = -(self.buttonsView.bounds.size.height + 8.);
    self.topLayoutLabelsView.constant = -(self.labelsView.bounds.size.height + 28.);
    self.trailingZoomsView.constant = (self.zoomButtonsView.bounds.size.width + 28.);
    [self.view setNeedsUpdateConstraints];
    
    [self showButtonViewAnimate];
    [self showLabelsViewAnimate];
    [self showZoomViewAnimate];


    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
