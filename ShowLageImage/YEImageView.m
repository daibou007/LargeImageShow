//
//  YEImageView.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "YEImageView.h"

@implementation YEImageView {
    UIImage *originImage;
    CGRect imageRect;
    CGFloat imageScale;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass {
    return [CATiledLayer class];
}
- (id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.tileCount = 36;
        self.imageName = imageName;
        
        [self initSelf];
    }
    return self;
}

- (id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount {
    self = [self initWithFrame:frame];

    if (self) {
        self.tileCount = tileCount;
        self.imageName = imageName;
        [self initSelf];
    }
    return self;
}

- (id)initWithImageURL:(NSString *)imageURL andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount {
    self = [self initWithFrame:frame];

    if (self) {
        self.tileCount = tileCount;
        self.imageURL = imageURL;
        [self initSelf];
    }
    return self;
}

- (void)initSelf {
    if(_imageName){
        NSString *path                = [[NSBundle mainBundle] pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
        originImage                   = [self fixOrientation:[UIImage imageWithContentsOfFile:path]];
        imageRect                     = CGRectMake(0.0f, 0.0f, CGImageGetWidth(originImage.CGImage), CGImageGetHeight(originImage.CGImage));
        imageScale                    = self.frame.size.width / imageRect.size.width;
        CATiledLayer *tiledLayer      = (CATiledLayer *) [self layer];
        
        int lev                       = ceil(log2(1 / imageScale)) + 1;
        tiledLayer.levelsOfDetail     = 1;
        tiledLayer.levelsOfDetailBias = lev;
        if (self.tileCount > 0) {
            NSInteger tileSizeScale = sqrt(self.tileCount) / 2;
            CGSize tileSize         = self.bounds.size;
            tileSize.width          /= tileSizeScale;
            tileSize.height         /= tileSizeScale;
            tiledLayer.tileSize     = tileSize;
        }
    }else if(_imageURL){
//        NSString *path                = [[NSBundle mainBundle] pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
        originImage                   = [self fixOrientation:[UIImage imageWithContentsOfFile:_imageURL]];
        imageRect                     = CGRectMake(0.0f, 0.0f, CGImageGetWidth(originImage.CGImage), CGImageGetHeight(originImage.CGImage));
        imageScale                    = self.frame.size.width / imageRect.size.width;
        CATiledLayer *tiledLayer      = (CATiledLayer *) [self layer];
        
        int lev                       = ceil(log2(1 / imageScale)) + 1;
        tiledLayer.levelsOfDetail     = 1;
        tiledLayer.levelsOfDetailBias = lev;
        if (self.tileCount > 0) {
            NSInteger tileSizeScale = sqrt(self.tileCount) / 2;
            CGSize tileSize         = self.bounds.size;
            tileSize.width          /= tileSizeScale;
            tileSize.height         /= tileSizeScale;
            tiledLayer.tileSize     = tileSize;
        }
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    imageScale = self.frame.size.width / imageRect.size.width;
    if (self.tileCount > 0) {
        CATiledLayer *tileLayer = (CATiledLayer *) self.layer;
        CGSize tileSize         = self.bounds.size;
        NSInteger tileSizeScale = sqrt(self.tileCount) / 2;
        tileSize.width          /= tileSizeScale;
        tileSize.height         /= tileSizeScale;
        tileLayer.tileSize      = tileSize;
    }
}
- (CGPoint)rectCenter:(CGRect)rect {
    CGFloat centerX = (CGRectGetMaxX(rect) + CGRectGetMinX(rect)) / 2;
    CGFloat centerY = (CGRectGetMaxY(rect) + CGRectGetMinY(rect)) / 2;

    return CGPointMake(centerX, centerY);
}

- (void)drawRect:(CGRect)rect {
    // 将视图frame映射到实际图片的frame
    CGRect imageCutRect = CGRectMake(rect.origin.x / imageScale, rect.origin.y / imageScale, rect.size.width / imageScale, rect.size.height / imageScale);
    // 截取指定图片区域，重绘
    @autoreleasepool {
        CGImageRef imageRef  = CGImageCreateWithImageInRect(originImage.CGImage, imageCutRect);
        UIImage *tileImage   = [UIImage imageWithCGImage:imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect:rect];
        UIGraphicsPopContext();
    }
    static NSInteger drawCount = 1;
    drawCount++;
    if (drawCount == self.tileCount) {
    }
}

- (CGSize)returnTileSize {
    return [(CATiledLayer *) self.layer tileSize];
}

/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown :
        case UIImageOrientationDownMirrored :
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft :
        case UIImageOrientationLeftMirrored :
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight :
        case UIImageOrientationRightMirrored :
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default :
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored :
        case UIImageOrientationDownMirrored :
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored :
        case UIImageOrientationRightMirrored :
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default :
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft :
        case UIImageOrientationLeftMirrored :
        case UIImageOrientationRight :
        case UIImageOrientationRightMirrored :
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;

        default :
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img     = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
