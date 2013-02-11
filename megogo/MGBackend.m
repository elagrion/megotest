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

const NSUInteger kMGBackendGetCategory = 4;
const NSUInteger kMGBackendGetGenre = 18;
static NSString* kMGBackendGetK2 = @"ca757b409b6b7552";
static NSString* kMGBackendGetK1 = @"_fortest";

static MGBackend* sBackend = nil;

@implementation MGBackend

+ (MGBackend*) sharedBackend
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sBackend = [[MGBackend alloc] init];
	});
	return sBackend;
}

- (void) getFilmList
{
	[self getFilmListWithOffset: 50 limit: 100];
}

- (void) getFilmListWithOffset: (NSUInteger) offset limit: (NSUInteger) limit
{
		//@"/p/videos?category=<cat_id>[&genre=<genre_id>&session=<session_id>&offset=<offset>&limit=<limit>]&sign=<sign>"

	NSString* categoryStr = [NSString stringWithFormat: @"category=%u", kMGBackendGetCategory];
	NSString* genreStr = [NSString stringWithFormat: @"genre=%u", kMGBackendGetGenre];
	NSString* offsetStr = [NSString stringWithFormat: @"offset=%u", offset];
	NSString* limitStr = [NSString stringWithFormat: @"limit=%u", limit];

	NSString* str = [NSString stringWithFormat:@"%@%@%@%@%@", categoryStr, genreStr, offsetStr, limitStr, kMGBackendGetK2];
	NSString* sign = [[str MD5String] stringByAppendingString: kMGBackendGetK1];

	NSString* cmdStr = [NSString stringWithFormat: @"http://megogo.net/p/videos?%@&%@&%@&%@&sing=%@", categoryStr, genreStr, offsetStr, limitStr, sign];

//		NSString* str = [NSString stringWithContentsOfURL:(NSURL *) encoding:(NSStringEncoding) error:(NSError *__autoreleasing *)]
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: cmdStr]];
	[request setHTTPMethod: @"GET"];

	[NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error)
		{
			NSLog(@"getFilmList request error: %@", error);
			return;
		}

		if ([(NSHTTPURLResponse*)response statusCode] != 200)
		{
			NSLog(@"can't recive url: %@ with status code: %u", [response URL], [(NSHTTPURLResponse*)response statusCode]);
			return;
		}

		id object = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
		NSLog(@"%@", object);
		if ([object isKindOfClass: [NSDictionary class]])
		{
			NSArray* films = [[object objectForKey: @"data"] objectForKey: @"video_list"];
			for (NSDictionary* film in films)
			{
				
			}
		}
	}];
}

- (void) getFilmInfoForFilmId: (NSUInteger) filmId
{
	NSString* videoStr = [NSString stringWithFormat: @"video=%u", filmId];

	NSString* str = [NSString stringWithFormat:@"%@%@", videoStr, kMGBackendGetK2];
	NSString* sign = [[str MD5String] stringByAppendingString: kMGBackendGetK1];

	NSString* cmdStr = [NSString stringWithFormat: @"http://megogo.net/p/video?%@&sing=%@", videoStr, sign];

		//		NSString* str = [NSString stringWithContentsOfURL:(NSURL *) encoding:(NSStringEncoding) error:(NSError *__autoreleasing *)]
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: cmdStr]];
	[request setHTTPMethod: @"GET"];

	[NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
		if (error)
		{
			NSLog(@"getFilmList request error: %@", error);
			return;
		}

		if ([(NSHTTPURLResponse*)response statusCode] != 200)
		{
			NSLog(@"can't recive url: %@ with status code: %u", [response URL], [(NSHTTPURLResponse*)response statusCode]);
			return;
		}

		id object = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
		NSLog(@"%@", object);
	}];
}

@end