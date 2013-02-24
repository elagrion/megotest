//
//  MGFilmInfo.h
//  megogo
//
//  Created by Agapov Oleg on 2/10/13.
//  Copyright (c) 2013 Agapov Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGFilmInfo : NSObject

- (id) initWithId: (NSString*) aFilmId;
- (id) initWithId: (NSString*) aFilmId title: (NSString*) aTitle rank: (NSString*) aRank;

@property (retain) NSString* filmId;
@property (retain) NSString* title;
@property (retain) NSString* rank;
@property (retain, nonatomic) NSURL* posterURL;
@property (retain) UIImage* poster;

@end
