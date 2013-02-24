//
//  MGFilmInfo.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import "MGFilmInfo.h"

@implementation MGFilmInfo

- (id) initWithId: (NSString*) aFilmId title: (NSString*) aTitle rank: (NSString*) aRank
{
	if (self = [super init])
	{
		_filmId = aFilmId;
		_title = aTitle;
		_rank = aRank;
	}
	return self;
}

- (id) initWithId: (NSString*) aFilmId
{
	if (self = [super init])
	{
		_filmId = aFilmId;
	}
	return self;
}

//- (void) setPosterURL: (NSURL*) aPosterURL
//{
//	_posterURL = aPosterURL;
//	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//	dispatch_async(queue, ^{
//		self.poster = [UIImage imageWithData: [NSData dataWithContentsOfURL: aPosterURL]];
//	});
//}

- (void) dealloc
{
    _filmId = nil;
	_title = nil;
	_rank = nil;
	_posterURL = nil;
}

- (NSString*)description
{
	return [[super description] stringByAppendingString: self.title];
}

@end
