//
//  MGFilmInfo.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import "MGFilmInfo.h"

@implementation MGFilmInfo

- (id) initWithId: (NSString*) aFilmId title: (NSString*) aTitle rank: (NSString*) aRank image: (UIImage*) aPoster
{
	if (self = [super init])
	{
		_filmId = aFilmId;
		_title = aTitle;
		_rank = aRank;
		_poster = aPoster;
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

- (void)dealloc
{
    _filmId = nil;
	_title = nil;
	_rank = nil;
	_poster = nil;
}

@end
