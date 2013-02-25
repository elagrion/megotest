//
//  MGBackend.m
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

@interface NSString (MD5)

- (NSString *)MD5String;

@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5String {
	const char *cstr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cstr, strlen(cstr), result);

	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end

#import "MGBackend.h"
#import "MGFilmInfo.h"

const NSUInteger kMGBackendGetCategory = 16;
const NSUInteger kMGBackendGetGenre = 12;
static NSString* kMGBackendGetK2 = @"ca757b409b6b7552";
static NSString* kMGBackendGetK1 = @"_fortest";

@implementation MGBackend

- (void) getFilmListWithOffset: (NSUInteger) offset limit: (NSUInteger) limit
{
				//TODO: dispatch thread
	NSString* categoryStr = [NSString stringWithFormat: @"category=%u", kMGBackendGetCategory];
	NSString* genreStr = [NSString stringWithFormat: @"genre=%u", kMGBackendGetGenre];
	NSString* limitStr = [NSString stringWithFormat: @"limit=%u", limit];
	NSString* offsetStr = [NSString stringWithFormat: @"offset=%u", offset];

	NSString* str = [NSString stringWithFormat:@"%@%@%@%@%@", categoryStr, genreStr, limitStr, offsetStr, kMGBackendGetK2];
	NSString* sign = [[[str MD5String] stringByAppendingString: kMGBackendGetK1] lowercaseString];

	NSString* cmdStr = [NSString stringWithFormat: @"http://megogo.net/p/videos?%@&%@&%@&%@&sign=%@", categoryStr, genreStr, limitStr, offsetStr, sign];

	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: cmdStr]];
	[request setHTTPMethod: @"GET"];

	[NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error)
		{
			NSLog(@"getFilmList request error: %@", error);
			[self.delegate backend: self failedWithError: error];
			return;
		}

		if ([(NSHTTPURLResponse*)response statusCode] != 200)
		{
			NSLog(@"can't recive url: %@ with status code: %u", [response URL], [(NSHTTPURLResponse*)response statusCode]);
			[self.delegate backend: self failedWithError: nil];
			return;
		}

		id object = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
		if ([object isKindOfClass: [NSDictionary class]])
		{
			NSArray* films = [object objectForKey: @"video_list"];
			NSMutableArray* newFilms = [NSMutableArray arrayWithCapacity: [films count]];
			for (NSDictionary* film in films)
			{
				MGFilmInfo* filmInfo = [[MGFilmInfo alloc] initWithId: [film objectForKey: @"id"]
																title: [film objectForKey: @"title"]
																 rank: [film objectForKey: @"rating_kinopoisk"]];
				filmInfo.filmDescription = [film objectForKey: @"description"];
				NSString* strURL = [NSString stringWithFormat: @"http://megogo.net%@", [film objectForKey: @"poster"]];
				filmInfo.posterURL = [NSURL URLWithString: strURL];
				[newFilms addObject: filmInfo];
			}
			NSUInteger total = [[object objectForKey: @"total_num"] integerValue];
			[self.delegate backend: self didGetFilmsInfo: newFilms totalFilms: total];
		}
	}];
}

- (void) getFilmStreamForId: (NSString*) filmId
{
	///p/info?video=<id>[&season=<season_id>&episode=<episode_id>]&sign=<sign]
	NSString* videoStr = [NSString stringWithFormat: @"video=%@", filmId];

	NSString* str = [NSString stringWithFormat:@"%@%@", videoStr, kMGBackendGetK2];
	NSString* sign = [[[str MD5String] stringByAppendingString: kMGBackendGetK1] lowercaseString];

	NSString* cmdStr = [NSString stringWithFormat: @"http://megogo.net/p/info?%@&sign=%@", videoStr, sign];

	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: cmdStr]];
	[request setHTTPMethod: @"GET"];

	[NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error)
		{
			NSLog(@"getFilmStreamForId request error: %@", error);
			[self.delegate backend: self failedWithError: error];
			return;
		}

		if ([(NSHTTPURLResponse*)response statusCode] != 200)
		{
			NSLog(@"can't recive url: %@ with status code: %u", [response URL], [(NSHTTPURLResponse*)response statusCode]);
			[self.delegate backend: self failedWithError: nil];
			return;
		}

		id object = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
		NSURL* streamURL = [NSURL URLWithString: [object objectForKey: @"src"]];
		[self.delegate backend: self didGetStreamURL: streamURL];
	}];
}

@end
