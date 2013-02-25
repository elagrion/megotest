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

- (void) getFilmListWithOffset: (NSUInteger) offset limit: (NSUInteger) limit;
- (void) getFilmStreamForId: (NSString*) filmId;

@end

@protocol backendProtocol
@optional
- (void) backend: (MGBackend*) backend didGetStreamURL: (NSURL*) aStreamURL;
- (void) backend: (MGBackend*) backend didGetFilmsInfo: (NSArray*) films totalFilms: (NSUInteger) aTotalFilms;
@required
- (void) backend: (MGBackend *)backend failedWithError: (NSError*) error;
@end
