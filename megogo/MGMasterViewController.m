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
	
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count + 1;
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
			[self loadPictureFroIndexPath: indexPath];
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

- (void) backend: (MGBackend*) backend didGetFilmsInfo: (NSArray*) films
{
	[_objects addObjectsFromArray: films];
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
