//
//  Cache.h
//  StanfordTour
//
//  Created by Eugene Chuvyrov on 3/23/13.
//  Copyright (c) 2013 Eugene Chuvyrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

- (void)removeImage:(NSString*)fileName;
- (void)saveImage:(UIImage*)image imageName:(NSString*)imageName;
- (NSData*)loadImage:(NSString*)imageName;

@end
