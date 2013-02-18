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

@property (retain) NSString* filmId;
@property (retain) NSString* title;
@property (retain) NSString* rank;
@property (retain) UIImage* poster;

@end
