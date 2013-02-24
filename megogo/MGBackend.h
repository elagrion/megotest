//
//  MGBackend.h
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol backendProtocol;

@interface MGBackend : NSObject

@property (nonatomic, weak) id<backendProtocol> delegate;
+ (MGBackend*) sharedBackend;
- (void) getFilmListWithOffset: (NSUInteger) offset limit: (NSUInteger) limit;
- (void) getFilmList;
- (void) getFilmInfoForFilmId: (NSUInteger) filmId;
- (void) getPictureFroURL: (NSURL*) url;

@end

@protocol backendProtocol
@required
- (void) backend: (MGBackend*) backend didGetFilmsInfo: (NSArray*) films totalFilms: (NSUInteger) aTotalFilms;
@end
