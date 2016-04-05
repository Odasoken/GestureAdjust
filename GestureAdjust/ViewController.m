//
//  ViewController.m
//  GestureAdjust
//
//  Created by juliano on 3/16/16.
//  Copyright © 2016 juliano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic)  UIView *whiteView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.greenView addSubview:whiteView];
    self.whiteView = whiteView;
    
    
    //add gesture to view
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGestureRecognizer.delegate = self;
    [whiteView addGestureRecognizer:pinchGestureRecognizer];
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [panGestureRecognizer setDelegate:self];
    [whiteView  addGestureRecognizer:panGestureRecognizer];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.whiteView.frame = CGRectMake(10, 10, CGRectGetWidth(self.greenView.frame) - 10 * 2, CGRectGetHeight(self.greenView.frame) - 10 * 2);
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.whiteView.frame = CGRectMake(10, 10, CGRectGetWidth(self.greenView.frame) - 10 * 2, CGRectGetHeight(self.greenView.frame) - 10 * 2);
}


#pragma mark - Gesture
/**
 *  pinch
 *
 *
 */
-(void)pinchImage:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        CGFloat estimatedWidth = scale * CGRectGetWidth(self.whiteView.frame);
        if (estimatedWidth < CGRectGetWidth(self.whiteView.superview.frame) * 0.4) {
            return;
        }
        self.whiteView.frame = CGRectMake(self.whiteView.frame.origin.x, self.whiteView.frame.origin.y, scale * CGRectGetWidth(self.whiteView.frame), scale * CGRectGetHeight(self.whiteView.frame));
        self.whiteView.center = CGPointMake(CGRectGetWidth(self.whiteView.superview.frame) * 0.5, CGRectGetHeight(self.whiteView.superview.frame) * 0.5);
        [recognizer setScale:1.0];
        
    }
}

/**
 *  pan
 *
 *
 */
- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat ratio = 0.6;
        CGFloat estimatedX = recognizer.view.frame.origin.x + translation.x;
        CGFloat estimatedY = recognizer.view.frame.origin.y + translation.y;
        CGFloat estimatedMaxX = estimatedX + CGRectGetWidth(recognizer.view.frame);
         CGFloat estimatedMaxY= estimatedY + CGRectGetHeight(recognizer.view.frame);
        CGFloat superWidth = CGRectGetWidth(recognizer.view.superview.frame);
        CGFloat superHeight = CGRectGetHeight(recognizer.view.superview.frame);
        if ((estimatedMaxX < superWidth * (1-ratio)) || estimatedMaxY < superHeight * ratio ||estimatedX > superWidth * ratio || estimatedY > superHeight * (1 -ratio)) {
            return;
        }
        recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x + translation.x, recognizer.view.frame.origin.y + translation.y, CGRectGetWidth(recognizer.view.frame), CGRectGetHeight(recognizer.view.frame));

        
//        NSLog(@"******%@********",NSStringFromCGRect(recognizer.view.frame));
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
