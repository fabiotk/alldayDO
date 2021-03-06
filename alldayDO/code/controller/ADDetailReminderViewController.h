//
//  ADDetailReminderViewController.h
//  alldayDO
//
//  Created by Fábio Almeida on 8/13/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADLembreteConfirmado.h"
#import "ADDetailReminderViewModel.h"

@interface ADDetailReminderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *monthContentView;
@property (strong, nonatomic) IBOutlet UIView *weekContentView;
@property (strong, nonatomic) IBOutlet UIView *borderContentView;

@property (strong, nonatomic) IBOutlet UIView *inLineContentView;
@property (strong, nonatomic) IBOutlet UIView *inLineBorderContentView;

@property (weak, nonatomic) IBOutlet UIView *chartContentView;
@property (weak, nonatomic) IBOutlet UIView *chartBorderContentView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UILabel *monthTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inLineTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekLabel;
@property (strong, nonatomic) IBOutlet UILabel *inLineLabel;

@property (weak, nonatomic) IBOutlet UIImageView *graphicIcon;

@property (nonatomic, strong) ADDetailReminderViewModel *viewModel;

- (IBAction)editButtonTouched:(id)sender;
- (IBAction)doneButtonTouched:(id)sender;

@end
