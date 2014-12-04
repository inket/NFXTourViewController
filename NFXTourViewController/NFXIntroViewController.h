//
//  NFXIntroViewController.h
//
//  Created by Tomoya_Hirano on 2014/10/04.
//  Modified by Mahdi Bchetnia on 2014/12/04.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFXIntroViewController : UIViewController

/**
 *  Presents the intro view controller modally
 *
 *  @param viewController The view controller in charge of presenting the intro view controller
 *  @param images         The intro images
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion     The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 *
 *  @return The created intro view controller
 */
+ (instancetype)presentInViewController:(UIViewController*)viewController
                             withImages:(NSArray*)images
                               animated:(BOOL)animated
                             completion:(void (^)())completion;

/**
 *  Initializes the intro view controller with the provided images
 *
 *  @param images The intro images
 *
 *  @return self
 */
- (instancetype)initWithViews:(NSArray*)images;

@end

@interface UIColor(NFXUIColorToUIImage)

/**
 *  Create and return a fill image of this color
 *
 *  @return The image
 */
- (UIImage*)nfx_fillImage;

@end
