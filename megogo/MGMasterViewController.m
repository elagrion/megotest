//
//  MGMasterViewController.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import "MGMasterViewController.h"
#import "MGDetailViewController.h"
#import "MGFilmInfo.h"
#import "MGBackend.h"

@interface MGMasterViewController () <backendProtocol>
@property (unsafe_unretained) NSUInteger totalFilms;
@end

@implementation MGMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	[MGBackend sharedBackend].delegate = self;
	_objects = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPictureFroIndexPath: (NSIndexPath*) indexPath
{
//	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//	dispatch_async(queue, ^{
		MGFilmInfo* film = [_objects objectAtIndex: indexPath.row];
		UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [film posterURL]]];
		film.poster = image;
	//	[self performSelectorOnMainThread: @selector(refreshImageAtIndexPath:) withObject: indexPath waitUntilDone: NO];
		dispatch_async(dispatch_get_main_queue(), ^{
			//[self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
			cell.imageView.image = image;
		});

//	});
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
		[[MGBackend sharedBackend] getFilmListWithOffset: _objects.count limit: 10];
	}

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark backend

- (void) backend: (MGBackend*) backend didGetFilmsInfo: (NSArray*) aFilms totalFilms: (NSUInteger) aTotalFilms
{
	[_objects addObjectsFromArray: aFilms];
	self.totalFilms = aTotalFilms;
	[self.tableView reloadData];
}

#pragma mark scene

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
