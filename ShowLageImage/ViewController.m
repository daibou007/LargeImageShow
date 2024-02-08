//
//  ViewController.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/2.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "ViewController.h"
#import "LargeImageView.h"
#import "UIImage+YEImage.h"
#import "BaseButton.h"
#import "YeFileManager.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic) NSInteger imagesIndex;
@property (nonatomic) NSInteger tileCount;
@property (nonatomic) CGRect defaultFrame;
@property (nonatomic, strong) LargeImageView *largeImageView;
;

@end

@implementation ViewController {
    BaseButton *button0;

    BaseButton *button4;
    BaseButton *button16;
    BaseButton *button36;
    BaseButton *button64;
    BaseButton *button100;
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];

    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
    self.images             = [[NSArray alloc] initWithContentsOfFile:plistPath];
    //    self.images = [[NSMutableArray alloc] initWithArray:@[ @"zz.jpg", @"7L2A1057.JPG" ]];

    /**截取按钮图片**/
    UIImage *image      = [UIImage imageNamed:@"按钮.png"];
    CGSize btnImageSize = CGSizeMake(image.size.width, (image.size.height - 32) / 2);
    UIImage *btnImage   = [image getSubImage:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
    /**截取按钮图片**/

    CGPoint center = self.view.center;
    button0        = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"100" andAction:@selector(buttonAction:) andTarget:self];
    [button0 setUpImage:btnImage andDownImage:btnImage];
    center.y       -= 250;
    button0.center = center;
    [self.view addSubview:button0];

    button4 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"200" andAction:@selector(buttonAction:) andTarget:self];
    [button4 setUpImage:btnImage andDownImage:btnImage];
    center.y       += 50;
    button4.center = center;
    [self.view addSubview:button4];
    button16 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"300" andAction:@selector(buttonAction:) andTarget:self];
    [button16 setUpImage:btnImage andDownImage:btnImage];
    center.y        += 50;
    button16.center = center;
    [self.view addSubview:button16];
    button36 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"400" andAction:@selector(buttonAction:) andTarget:self];
    [button36 setUpImage:btnImage andDownImage:btnImage];
    center.y        += 50;
    button36.center = center;
    [self.view addSubview:button36];
    button64 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"800" andAction:@selector(buttonAction:) andTarget:self];
    [button64 setUpImage:btnImage andDownImage:btnImage];
    center.y        += 50;
    button64.center = center;
    [self.view addSubview:button64];
    button100 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"open" andAction:@selector(buttonAction:) andTarget:self];
    [button100 setUpImage:btnImage andDownImage:btnImage];
    center.y         += 50;
    button100.center = center;
    [self.view addSubview:button100];
}

- (void)imagePreAction:(BaseButton *)button {
    if (self.largeImageView) {
        [self.largeImageView removeFromSuperview];
        self.largeImageView = nil;
    }
    self.imagesIndex--;
    if (self.imagesIndex < 0) {
        self.imagesIndex = self.images.count - 1;
    }
    self.largeImageView          = [[LargeImageView alloc] initWithImageName:self.images[self.imagesIndex] andTileCount:self.tileCount];
//    self.largeImageView.delegate = self;
    self.defaultFrame            = CGRectMake(self.largeImageView.frame.origin.x, self.largeImageView.frame.origin.y, self.largeImageView.frame.size.width,
                                              self.largeImageView.frame.size.height);

    [self.view addSubview:self.largeImageView];
    self.largeImageView.center = self.view.center;
}

- (void)imageNextAction:(BaseButton *)button {
    if (self.largeImageView) {
        [self.largeImageView removeFromSuperview];
        self.largeImageView = nil;
    }
    self.imagesIndex++;
    if (self.imagesIndex >= self.images.count) {
        self.imagesIndex = 0;
    }
    self.largeImageView          = [[LargeImageView alloc] initWithImageName:self.images[self.imagesIndex] andTileCount:self.tileCount];
//    self.largeImageView.delegate = self;

    self.defaultFrame            = CGRectMake(self.largeImageView.frame.origin.x, self.largeImageView.frame.origin.y, self.largeImageView.frame.size.width,
                                              self.largeImageView.frame.size.height);

    [self.view addSubview:self.largeImageView];
    [self.largeImageView setNeedsDisplay];

    self.largeImageView.center = self.view.center;
}
- (void)buttonAction:(BaseButton *)button {
    if ([button.name isEqualToString:@"open"]) {
        [self importFile];
        return;
    }
    [button0 removeFromSuperview];
    [button4 removeFromSuperview];
    [button16 removeFromSuperview];
    [button36 removeFromSuperview];
    [button64 removeFromSuperview];
    [button100 removeFromSuperview];

    self.tileCount = [button.name integerValue];

    if (self.largeImageView) {
        [self.largeImageView removeFromSuperview];
        self.largeImageView = nil;
    }

    self.largeImageView          = [[LargeImageView alloc] initWithImageName:self.images[self.imagesIndex] andTileCount:self.tileCount];
//    self.largeImageView.delegate = self;

    self.defaultFrame            = CGRectMake(self.largeImageView.frame.origin.x, self.largeImageView.frame.origin.y, self.largeImageView.frame.size.width,
                                              self.largeImageView.frame.size.height);

    [self.view addSubview:self.largeImageView];
    self.largeImageView.center  = self.view.center;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.delegate                = self;

    [self.view addGestureRecognizer:tap];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];

    [self.view addGestureRecognizer:pinch];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:pan];
}

- (void)clearButtonAction:(BaseButton *)button {
    [self.largeImageView removeFromSuperview];
    self.largeImageView = nil;

    [self.view addSubview:button0];
    [self.view addSubview:button4];
    [self.view addSubview:button16];
    [self.view addSubview:button36];
    [self.view addSubview:button64];
    [self.view addSubview:button100];
}

static CGPoint originCenter;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    CGPoint trans = [gesture locationInView:self.view];
    if (trans.x > (2 * self.view.frame.size.width / 3)) {
        NSLog(@"imageNextAction");
        [self imageNextAction:nil];
    } else if (trans.x < (self.view.frame.size.width / 3)) {
        NSLog(@"imagePreAction");
        [self imagePreAction:nil];
    } else {
        NSLog(@"resetImage");
        [self resetImage];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    //    // 拖拽的距离(距离是一个累加)
    //    CGPoint trans = [gesture translationInView:self.view];
    //    NSLog(@"panGestureAction:%@", NSStringFromCGPoint(trans));
    //
    //    // 设置图片移动
    //    CGPoint center        = largeImageView.center;
    //    center.x              += trans.x;
    //    center.y              += trans.y;
    //    largeImageView.center = center;
    //
    //    NSLog(@"%@", NSStringFromCGRect(largeImageView.frame));
    //    // 清除累加的距离
    //    [gesture setTranslation:CGPointZero inView:self.view];
    //
    //    if (gesture.state == UIGestureRecognizerStateBegan) {
    //        originCenter = largeImageView.center;
    //    } else if (gesture.state == UIGestureRecognizerStateEnded) {
    //        CGPoint move          = CGPointMake(center.x - originCenter.x, center.y - originCenter.y);
    //        largeImageView.center = originCenter;
    //        CGRect frame          = largeImageView.frame;
    //        frame.origin.x        += move.x;
    //        frame.origin.y        += move.y;
    //        largeImageView.frame  = frame;
    //    }
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    //    largeImageView.transform = CGAffineTransformScale(largeImageView.transform, gesture.scale, gesture.scale);
    //    NSLog(@"pinchGestureAction:%f_____%@", gesture.scale, NSStringFromCGRect(largeImageView.frame));
    //
    //    gesture.scale = 1;
    //
    //    if (gesture.state == UIGestureRecognizerStateEnded) {
    //        CGRect newFrame          = largeImageView.frame;
    //        largeImageView.transform = CGAffineTransformIdentity;
    //        largeImageView.frame     = newFrame;
    //    }
}

- (void)resetImage {
    self.largeImageView.frame     = self.defaultFrame;
    self.largeImageView.center    = self.view.center;
    self.largeImageView.transform = CGAffineTransformIdentity;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"转屏前调入");
        if (self.largeImageView) {
            self.largeImageView.center = self.view.center;
        }
    }
        completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            NSLog(@"转屏后调入");
            //        if(largeImageView){
            //            largeImageView.center = self.view.center;
            //        }
        }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark 导入

- (void)importFile {
    [self presentDocumentPicker];
}

- (void)presentDocumentPicker {
    NSArray *types = @[
        @"public.data", 
        @"com.microsoft.powerpoint.ppt",
        @"com.microsoft.word.doc",
        @"com.microsoft.excel.xls",
        @"com.microsoft.powerpoint.pptx",
        @"com.microsoft.word.docx", 
        @"com.microsoft.excel.xlsx",
        @"public.avi",
        @"public.3gpp",
        @"public.mpeg-4",
        @"com.compuserve.gif",
        @"public.jpeg",
        @"public.png", 
        @"public.plain-text",
        @"com.adobe.pdf"
    ];  // 可以选择的文件类型

    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    documentPicker.delegate                        = self;
    documentPicker.modalPresentationStyle          = UIModalPresentationFullScreen;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(nonnull NSArray *)urls {
    for (NSURL *url in urls) {
        NSURL *tempURL             = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        NSData *fileData           = [NSData dataWithContentsOfURL:url];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath         = [tempURL.path stringByAppendingPathComponent:url.lastPathComponent];
        // If file with same name exists remove it
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error1 = nil;
            [fileManager removeItemAtPath:filePath error:&error1];
            NSLog(@"error%@", error1);
        }
        BOOL success = [fileData writeToFile:filePath atomically:YES];
        if (success) {
            NSLog(@"write file success");
        } else {
            NSLog(@"write file fail");
            return;
        }
        NSData *file = [NSData dataWithContentsOfFile:filePath];

        NSLog(@"file:%@", file);

        if (self.largeImageView) {
            [self.largeImageView removeFromSuperview];
            self.largeImageView = nil;
        }

        self.largeImageView          = [[LargeImageView alloc] initWithImageURL:filePath andTileCount:self.tileCount];
//        self.largeImageView.delegate = self;

        self.defaultFrame            = CGRectMake(self.largeImageView.frame.origin.x, self.largeImageView.frame.origin.y, self.largeImageView.frame.size.width,
                                                  self.largeImageView.frame.size.height);

        [self.view addSubview:self.largeImageView];
        self.largeImageView.center  = self.view.center;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tap.delegate                = self;

        [self.view addGestureRecognizer:tap];

        //        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
        //
        //        [self.view addGestureRecognizer:pinch];
        //
        //        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        //        [self.view addGestureRecognizer:pan];

        break;
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.largeImageView.yeImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
