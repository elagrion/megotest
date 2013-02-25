//
//  MGDetailViewController.h
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGFilmInfo;

@interface MGDetailViewController : UIViewController

@property (retain, nonatomic) MGFilmInfo* detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailPosterImage;
@end
