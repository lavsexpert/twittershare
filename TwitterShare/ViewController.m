//
//  ViewController.m
//  TwitterShare
//
//  Created by Sergey Lavrov on 20.02.2019.
//  Copyright © 2019 +1. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

- (void) configureTweetTextView;
- (void) showAlertMessage: (NSString *) myMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTweetTextView]; // Оформление
}

// Показ сообщения в модальном окне
- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Поделиться" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// При нажатии на кнопку
- (IBAction)showShareAction:(id)sender {
    // Скрываем клавиатуру если она открыта
    if([self.tweetTextView isFirstResponder]){
        [self.tweetTextView resignFirstResponder];
    }
    
    // Настраиваем окно с сообщением
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Поделиться" message:@"Где поделиться текстом?" preferredStyle:UIAlertControllerStyleAlert];
    
    // Настраиваем кнопку отмены
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault  handler:nil];
    
    // Настраиваем кнопку tweet
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Твитнуть" style:UIAlertActionStyleDefault  handler:
          ^(UIAlertAction *action){
              if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                  SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                  
                  // Отправляем текст в Twitter (обрезая до 140 символов, если он длиннее)
                  if([self.tweetTextView.text length] < 140){
                      [twitterVC setInitialText:self.tweetTextView.text];
                  } else {
                      NSString *shortText = [self.tweetTextView.text substringToIndex:140];
                      [twitterVC setInitialText:shortText];
                  }
                  [self presentViewController:twitterVC animated:YES completion:nil];
                  
              // Если не удалось подключиться к Twitter - сообщаем об этом
              } else {
                  [self showAlertMessage:@"Ты не вошёл в Twitter"];
              }
          }];
    
    // Настраиваем кнопку facebook
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Пост в Фейсбуке" style:UIAlertActionStyleDefault  handler:^(UIAlertAction *action){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            //[self showShareAction:@"Фейсбук доступен"];
            SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookVC setInitialText:self.tweetTextView.text];
            [self presentViewController:facebookVC animated:YES completion:nil];
        } else {
            [self showAlertMessage:@"Войдите в Фейсбук"];
        }
    }];
                                     

    // Добавляем кнопки
    [actionController addAction:facebookAction];
    [actionController addAction:tweetAction];
    [actionController addAction:cancelAction];

    // Показываем окно с сообщением
    [self presentViewController:actionController animated:YES completion:nil];
}

// Оформление текстового поля
- (void) configureTweetTextView{
    self.tweetTextView.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
    self.tweetTextView.layer.cornerRadius = 10.0;
    self.tweetTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.tweetTextView.layer.borderWidth = 2.0;
}

@end
