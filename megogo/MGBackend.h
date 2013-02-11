//
//  MGBackend.h
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGBackend : NSObject

+ (MGBackend*) sharedBackend;
- (void) getFilmListWithOffset: (NSUInteger) offset limit: (NSUInteger) limit;
- (void) getFilmList;
- (void) getFilmInfoForFilmId: (NSUInteger) filmId;

@end
