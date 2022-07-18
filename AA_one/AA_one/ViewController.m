//
//  ViewController.m
//  AA_one
//
//  Created by Jz D on 2022/7/18.
//

#import "ViewController.h"

#import "YYLabel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YYLabel * widget = [[YYLabel alloc] initWithFrame: UIScreen.mainScreen.bounds];
    [self.view addSubview: widget];
    NSString * path = [NSBundle.mainBundle pathForResource:@"dra" ofType:@"txt"];
    NSString * content = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: nil];
    widget.text = content;
    widget.font = [UIFont systemFontOfSize: 15];
    
    
    
}


@end
