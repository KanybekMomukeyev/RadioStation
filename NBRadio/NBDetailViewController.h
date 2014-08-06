//
//  NBDetailViewController.h
//  NBRadio
//
//  Created by Kanybek Momukeev on 06/08/14.
//  Copyright (c) 2014 Kanybek Momukeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBDetailViewController : UIViewController
@property (strong, nonatomic) NSDictionary *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
