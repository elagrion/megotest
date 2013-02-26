//
//  MGMasterViewController.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import "MGMasterViewController.h"
#import "MGFilmInfo.h"
#import "MGBackend.h"
#import "MGDetailViewController.h"

@interface MGMasterViewController () <backendProtocol>

@property (unsafe_unretained) NSUInteger totalFilms;
@property (retain, nonatomic) MGBackend* backend;

@end

@implementation MGMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target:self action:@selector(refreshData:)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void) awakeFromNib
{
	_backend = [[MGBackend alloc] init];
	_backend.delegate = self;
	_objects = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) refreshData: (id) sender
{
	[_objects removeAllObjects];
	self.totalFilms = 0;
	[self.tableView reloadData];
}

- (void) loadPictureFroIndexPath: (NSIndexPath*) indexPath
{
	MGFilmInfo* film = [_objects objectAtIndex: indexPath.row];
	UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [film posterURL]]];
	film.poster = image;
	dispatch_async(dispatch_get_main_queue(), ^{
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
		cell.imageView.image = image;
	});
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.totalFilms ? MIN(_objects.count + 1, self.totalFilms) : _objects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];

	if (indexPath.row < [_objects count])
	{
		MGFilmInfo *object = [_objects objectAtIndex: indexPath.row];
		cell.textLabel.text = object.title;
		cell.detailTextLabel.text = object.rank;
		if (object.poster)
		{
			cell.imageView.image = object.poster;
		}
		else
		{
			cell.imageView.image = [UIImage imageNamed: @"PlaceholderPoster"];
			[self performSelectorInBackground: @selector(loadPictureFroIndexPath:) withObject: indexPath];
		}
	}
	else
	{
		cell.textLabel.text = @"Loading…";
		[self.backend getFilmListWithOffset: _objects.count limit: 10];
	}
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark - Backend Delegate

- (void) backend: (MGBackend*) backend didGetFilmsInfo: (NSArray*) aFilms totalFilms: (NSUInteger) aTotalFilms
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[_objects addObjectsFromArray: aFilms];
		self.totalFilms = aTotalFilms;
		[self.tableView reloadData];
	});
}

- (void) backend:(MGBackend *)backend failedWithError: (NSError*) error
{
	NSString* message = error ? [error localizedDescription] : @"Coldn't load data, please retry.";
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Something went wrong" message: message delegate: nil cancelButtonTitle: @"Damn!" otherButtonTitles: nil];
	[alert show];
}

#pragma mark scene

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MGFilmInfo *object = [_objects objectAtIndex: indexPath.row];
        [[segue destinationViewController] setDetailItem :object];
    }
}

@end
