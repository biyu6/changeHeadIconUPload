//
//  MyViewController.m
//  test_home
//
//  Created by hc_hzc on 16/8/2.
//  Copyright © 2016年 hc_hzc. All rights reserved.
//

#import "MyViewController.h"
#import "UIImage+cutImage.h"
#import <objc/runtime.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define documentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface MyViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic, weak)UIImagePickerController *picker;

@end

@implementation MyViewController
#pragma mark- init初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self initView];
}
- (void)initView{
     UIImageView *imgV =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    //坐标及圆形剪切
    imgV.frame = CGRectMake(100, 100, 80, 80);
    [self.view addSubview:imgV];
    imgV.layer.cornerRadius = 40;
    imgV.layer.masksToBounds = YES;
    
    //添加手势
    imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconViewGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImgGest)];
    [imgV addGestureRecognizer:iconViewGest];
    
    self.imgV = imgV;
}

#pragma mark- 交互事件
- (void)clickIconImgGest{//点击了头像
    UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [myActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //设置照片来源
            //            picker.allowsEditing = YES;//编辑图像===自定义编辑界面
            [picker setModalPresentationStyle:UIModalPresentationFullScreen];
            [picker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [picker setAllowsEditing:YES];
            
            [self presentViewController:picker animated:YES completion:nil];
        }break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;//设置照片来源 为相机
            //            picker.allowsEditing = YES;//编辑图像===自定义编辑界面
            [picker setModalPresentationStyle:UIModalPresentationFullScreen];
            [picker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [picker setAllowsEditing:YES];
            
            [self presentViewController:picker animated:YES completion:nil];
        }break;
        default:
            break;
    }
}
#pragma mark- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = [UIImage imagewithImage:info[UIImagePickerControllerEditedImage]];
    
    self.imgName = [NSString stringWithFormat:@"%@.jpg", [[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"{TIFF}"]objectForKey:@"DateTime"]];
    [self performSelector:@selector(saveImage:)  withObject:image afterDelay:0.5];
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    self.picker = picker;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{//自定义图像编辑界面
    if (navigationController.viewControllers.count == 3)
    {
        Method method = class_getInstanceMethod([self class], @selector(drawRect:));
        class_replaceMethod([[[[navigationController viewControllers][2].view subviews][1] subviews][0] class],@selector(drawRect:),method_getImplementation(method),method_getTypeEncoding(method));
    }
}
-(void)drawRect:(CGRect)rect{//自定义图像编辑界面
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddRect(ref, rect);
    CGContextAddArc(ref, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, 0, M_PI*2, NO);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]setFill];
    CGContextDrawPath(ref, kCGPathEOFill);
    
    CGContextAddArc(ref, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, 0, M_PI*2, NO);
    [[UIColor whiteColor]setStroke];
    CGContextStrokePath(ref);
}




#pragma mark- 请求
- (void)saveImage:(UIImage *)image {//上传更换的头像并存入本地
//    WS(ws);
    //获取本地路径 待存入服务器后再存入本地
    NSString *imageFilePath = [documentsPath stringByAppendingPathComponent:@"selfPhoto.jpg"];
    UIImage *smallImage = [UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(90, 90)];
    
    //发送请求
    
//    requestHome.successBlock = ^(NSDictionary *dict){//请求成功========

        //获取服务器的头像URL=====存入单利中

        //将头像存入本地
        [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
#warning 仅仅是演示
        self.imgV.image = smallImage;
    
        [self.picker dismissViewControllerAnimated:YES completion:nil];

//    };
//    requestHome.failBlock = ^(NSDictionary *dict){//请求失败
//        [self.picker dismissViewControllerAnimated:YES completion:nil];
//    };

}


@end
