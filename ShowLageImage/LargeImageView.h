//
//  LargeImageView.h
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YEImageView.h"
#import "YEImageView1.h"

@interface LargeImageView : UIScrollView

@property (strong,nonatomic)NSString *imageName;
@property (strong,nonatomic)NSString *imageURL;
@property (strong,nonatomic) YEImageView *yeImageView;

@property NSInteger tileCount;
@property CGSize maxSize;

-(id)initWithImageName:(NSString*)imageName andTileCount:(NSInteger)tileCount;
- (id)initWithImageURL:(NSString*)imageURL andTileCount:(NSInteger)tileCount;

@end
