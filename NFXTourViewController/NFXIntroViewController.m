//
//  NFXIntroViewController.m
//
//  Created by Tomoya_Hirano on 2014/10/04.
//  Modified by Mahdi Bchetnia on 2014/12/04.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import "NFXIntroViewController.h"

#define kNextButtonTitle NSLocalizedString(@"Next", "Tour button 'Next'")
#define kStartButtonTitle NSLocalizedString(@"Start", "Tour button 'Start'")

#pragma mark - NFXIntroViewController

@interface NFXScrollView : UIScrollView @end

@interface NFXIntroViewController ()<UIScrollViewDelegate>;

@property (nonatomic, strong) UIView* containerView;

@property (nonatomic, strong) NFXScrollView* scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UIButton* nextButton;

@property (nonatomic, strong) NSArray* images;

@end

@implementation NFXIntroViewController

+ (instancetype)presentInViewController:(UIViewController*)viewController withImages:(NSArray*)images animated:(BOOL)animated completion:(void (^)())completion {
    NFXIntroViewController* introViewController = [[NFXIntroViewController alloc] initWithViews:images];
    [viewController presentViewController:introViewController animated:animated completion:completion];

    return introViewController;
}

- (id)initWithViews:(NSArray*)images {
    self = [super init];

    if (self)
    {
        NSAssert(images.count != 0, @"NFXIntroViewController cannot be initialized without images.");

        // Setup the view controller
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.images = images;

        // Calculate positions
        CGRect scrollViewRect = (CGRect){CGPointZero, CGSizeMake(self.view.bounds.size.width/3*2, self.view.bounds.size.height/3*2)};
        CGPoint scrollViewCenter = CGPointMake(self.view.center.x, self.view.center.y-50);

        CGSize pageControlSize = CGSizeMake(scrollViewRect.size.width * images.count, scrollViewRect.size.height);
        CGPoint pageControlCenter = CGPointMake(self.view.center.x, scrollViewCenter.y + (scrollViewRect.size.height/2) + 20);

        CGRect buttonRect = (CGRect){CGPointZero, CGSizeMake(250, 50)};
        CGPoint buttonCenter = CGPointMake(self.view.center.x, self.view.bounds.size.height-65);

        // Create the views
        CGFloat statusBarHeight = [UIScreen mainScreen].bounds.size.height;
        CGRect containerRect = self.view.bounds;
        containerRect.origin.y = statusBarHeight;
        containerRect.size.height -= statusBarHeight;
        _containerView = [[UIView alloc] initWithFrame:containerRect];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 14;
        _containerView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _containerView.layer.borderWidth = 1;
        [self.view addSubview:_containerView];

        _scrollView = [[NFXScrollView alloc] initWithFrame:scrollViewRect];
        _scrollView.center = scrollViewCenter;
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.contentSize = pageControlSize;
        _scrollView.pagingEnabled = true;
        _scrollView.bounces = false;
        _scrollView.delegate = self;
        _scrollView.layer.borderWidth = 0.5f;
        _scrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.layer.cornerRadius = 2;
        [_containerView addSubview:_scrollView];

        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
        _pageControl.numberOfPages = _images.count;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
        [_pageControl sizeToFit];
        _pageControl.center = pageControlCenter;
        [_containerView addSubview:_pageControl];

        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [_nextButton setTitle:kNextButtonTitle forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[[UIColor colorWithWhite:0.9 alpha:1] nfx_fillImage] forState:UIControlStateHighlighted];
        _nextButton.clipsToBounds = true;
        _nextButton.frame = buttonRect;
        _nextButton.center = buttonCenter;
        _nextButton.layer.cornerRadius = 4;
        _nextButton.layer.borderWidth = 0.5f;
        _nextButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        [_containerView addSubview:_nextButton];

        // Create the image views for each image
        NSInteger index = 0;
        for (UIImage* image in images)
        {
            NSAssert([image isKindOfClass:[UIImage class]], @"Unexpected object type: NFXIntroViewController only supports UIImage objects.");

            CGRect imageViewRect = CGRectMake(_scrollView.bounds.size.width * index,
                                              0,
                                              _scrollView.bounds.size.width,
                                              _scrollView.bounds.size.height);

            UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = true;
            imageView.image = image;
            [_scrollView addSubview:imageView];

            index++;
        }
    }

    return self;
}

- (void)buttonTapped:(UIButton*)button {
    NSInteger page = (NSInteger)round(_scrollView.contentOffset.x / _scrollView.frame.size.width);

    if (page != _images.count-1)
    {
        CGRect rect = _scrollView.frame;
        rect.origin.x = rect.size.width * (page+1);
        [_scrollView scrollRectToVisible:rect animated:true];
    }
    else
    {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)round(scrollView.contentOffset.x / scrollView.frame.size.width);

    if (page == _images.count-1)
    {
        [_nextButton setTitle:kStartButtonTitle forState:UIControlStateNormal];
    }
    else
    {
        [_nextButton setTitle:kNextButtonTitle forState:UIControlStateNormal];
    }

    _pageControl.currentPage = page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

#pragma mark - UIScrollView subclass to allow longer swipes

@implementation NFXScrollView

// Allow swipes starting from the screen edges (outside the scroll view)
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect newFrame = self.frame;
    newFrame = CGRectInset(self.bounds, -newFrame.origin.x, 0);
    return CGRectContainsPoint(newFrame, point);
}

@end

#pragma mark - UIColor helper category

@implementation UIColor(NFXUIColorToUIImage)

- (UIImage*)nfx_fillImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, self.CGColor);
    CGContextFillRect(contextRef, rect);
    UIImage *fillImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return fillImage;
}

@end
