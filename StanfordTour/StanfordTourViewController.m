//
//  StanfordTourViewController.m
//  StanfordTour
//
//  Created by Eugene Chuvyrov on 3/15/13.
//  Copyright (c) 2013 Eugene Chuvyrov. All rights reserved.
//

#import "StanfordTourViewController.h"
#import "TourCategoryPhotos.h"
#import "FlickrFetcher.h"

@interface StanfordTourViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation StanfordTourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadStanfordTourPhotos];
    [self.refreshControl addTarget:self
                            action:@selector(loadStanfordTourPhotos)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)loadStanfordTourPhotos {
    // start the animation if it's not already going
    [self.refreshControl beginRefreshing];
    [self.spinner startAnimating];
    // fork off the Flickr fetch into another thread
    //dispatch_queue_t loaderQ = dispatch_queue_create("flickr stanford tour", NULL);
    //dispatch_async(loaderQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        NSLog(@"%@", photos);
        [self aggregatePhotos:photos];
        
        [self.spinner stopAnimating];
        [self.refreshControl endRefreshing];
    //});
}

-(void)aggregatePhotos:(NSArray *)photos
{
    NSMutableArray* groupedPhotos = [[NSMutableArray alloc] init];
    
    for(NSDictionary* photo in photos){
        NSString* tags = [photo objectForKey:FLICKR_TAGS];
        NSArray *arrTags = [tags componentsSeparatedByString:@" "];
        
        for(NSString* tag in arrTags){
            if(![tag isEqualToString:@"cs193pspot"] && ![tag isEqualToString:@"portrait"] && ![tag isEqualToString:@"landscape"]){
            
                //scan through all objects in the array--do we already have this category?
                BOOL tagExists = FALSE;
                for(TourCategoryPhotos* cat in groupedPhotos){
                    if([cat.categoryName isEqualToString:[tag capitalizedString]]){
                        [cat.flickrPhotos addObject:photo];
                        cat.categoryDescription = [NSString stringWithFormat:@"%d photos", cat.flickrPhotos.count];
                        tagExists = TRUE;
                    }
                }
                
                if(tagExists == FALSE) {
                        //add a new object
                        TourCategoryPhotos *categoryPhoto = [[TourCategoryPhotos alloc] init];
                        categoryPhoto.categoryName = [tag capitalizedString];
                        categoryPhoto.categoryDescription = @"1 photo";
                        //categoryPhoto.categoryDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
                        categoryPhoto.flickrPhotos = [[NSMutableArray alloc] init];
                        [categoryPhoto.flickrPhotos addObject:photo];
                        
                        [groupedPhotos addObject:categoryPhoto];
                }
            }
        }
    }
    
    NSArray *sortedGroupPhotos;
    sortedGroupPhotos = [groupedPhotos sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(TourCategoryPhotos*)a categoryName];
        NSString *second = [(TourCategoryPhotos*)b categoryName];
        return [first compare:second];
    }];
    
    self.photos = sortedGroupPhotos;
}

@end
