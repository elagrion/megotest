//
//  MGDetailViewController.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import "MGDetailViewController.h"
#import "MGFilmInfo.h"
#import "MGBackend.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MGDetailViewController () <backendProtocol>
@property (retain, nonatomic) MGBackend* backend;
- (void)configureView;
@end

@implementation MGDetailViewController

#pragma mark - Managing the detail item

- (void)setFilmInfo:(MGFilmInfo*)newFilmInfo
{
    if (_detailItem != newFilmInfo)
	{
        _detailItem = newFilmInfo;
        [self configureView];
    }
}

- (void)configureView
{
	if (self.detailItem)
	{
	    self.detailDescriptionLabel.text = self.detailItem.filmDescription;
		self.detailPosterImage.image = self.detailItem.poster;
		self.navigationItem.title = self.detailItem.title;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemPlay target:self action:@selector(playFilm:)];
	self.navigationItem.rightBarButtonItem = playButton;
	[self configureView];
}

- (void) playFilm: (id) sender
{
	[self.backend getFilmStreamForId: self.detailItem.filmId];
}

- (MGBackend*) backend
{
	if (_backend == nil)
	{
		_backend = [[MGBackend alloc] init];
		_backend.delegate = self;
	}
	return _backend;
}

#pragma mark - Backend Delegate

- (void) backend: (MGBackend*) backend didGetStreamURL: (NSURL*) aStreamURL;
{
	MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL: aStreamURL];
	[self presentMoviePlayerViewControllerAnimated: player];
}

- (void) backend:(MGBackend *)backend failedWithError: (NSError*) error
{
	NSString* message = error ? [error localizedDescription] : @"Coldn't load data, please retry.";
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Something went wrong" message: message delegate: nil cancelButtonTitle: @"Damn!" otherButtonTitles: nil];
	[alert show];
}

@end
