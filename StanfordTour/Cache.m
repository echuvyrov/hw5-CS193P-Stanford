//
//  Cache.m
//  StanfordTour
//
//  Created by Eugene Chuvyrov on 3/23/13.
//  Copyright (c) 2013 Eugene Chuvyrov. All rights reserved.
//

#import "Cache.h"

@implementation Cache

- (void)saveImage:(UIImage*)image imageName:(NSString*)imageName {
    //convert image into .png format.
    NSData *imageData = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", imageName]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    NSLog(@"image saved");  
}

- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    NSLog(@"image removed");
}

- (NSData*)loadImage:(NSString*)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", imageName]];
    
    return [NSData dataWithContentsOfFile:fullPath];
}

@end
