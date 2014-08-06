//
//  NBMasterViewController.m
//  NBRadio
//
//  Created by Kanybek Momukeev on 06/08/14.
//  Copyright (c) 2014 Kanybek Momukeev. All rights reserved.
//

#import "NBMasterViewController.h"
#import "NBDetailViewController.h"
#import "NBNetworkManager.h"
#import "SVProgressHUD.h"
#import "NBRadioTVCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+BlockSegue.h"

@interface NBMasterViewController () {
}

@property (nonatomic, strong) NSArray *objects;
@end

@implementation NBMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.objects) {
        [SVProgressHUD showWithStatus:@"Загрузка"];
        [[NBNetworkManager sharedInstance] allRadioStationsWithCompletion:^(NSArray *response, NSError *error){
            if (!error) {
                self.objects = [NSArray arrayWithArray:response];
                [SVProgressHUD showSuccessWithStatus:@"Данные получены!"];
                [self.tableView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"Ошибка!"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBRadioTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBRadioTVCell" forIndexPath:indexPath];
    NSDictionary *objectDict = self.objects[indexPath.row];
    cell.titlCellLabel.text = [objectDict objectForKey:@"name"];
    [cell.radioCellImageView setImageWithURL:[NSURL URLWithString:[objectDict objectForKey:@"preview"]]
                            placeholderImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:nil withBlock:^(id sender, NBDetailViewController *destVC){
        NSDictionary *objectDict = self.objects[indexPath.row];
        [destVC setDetailItem:objectDict];
    }];
}

@end
