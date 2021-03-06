//
//  ADDetailReminderViewController.m
//  alldayDO
//
//  Created by Fábio Almeida on 8/13/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADDetailReminderViewController.h"
#import "ADEditReminderViewController.h"
#import "PNChart.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height - 568) ? NO : YES)

@interface ADDetailReminderViewController () <ADEditReminderViewControllerDelegate>

@property (nonatomic, strong) PNLineChart *lineChart;

- (void)_animationToPortraitRotationChartView;
- (void)_animationToLandscapeRotationChartView;
- (void)_updateInterface;
- (void)_updateChart;
- (void)_presentNewReminderViewController;
- (void)_IBOutletTitle;
- (NSString *)_doneButtonTitles;

//- (void)willRotateToInterfaceOrientation:(NSNotification *)notification;
@end

@implementation ADDetailReminderViewController

#pragma mark - UIView Lifecycle Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContentView addSubview:self.lineChart];
    [self _IBOutletTitle];
    self.doneButton.layer.masksToBounds = YES;
    self.doneButton.layer.cornerRadius = 10.f;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(willRotateToInterfaceOrientation:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GAI sharedInstance] sendScreen:@"DetailReminderScreen" withCategory:@"Screen"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_second_color_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self _updateInterface];
}

#pragma mark - Getter Methods -

- (ADDetailReminderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ADDetailReminderViewModel alloc] init];
    }
    return _viewModel;
}

- (PNLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:self.chartContentView.bounds];
        [_lineChart setW:_lineChart.width + 60.f];
        [_lineChart setX:-15.f];
        
        // TODO POG - GAMBIARRA
        if (IS_IPHONE5) {
            [_lineChart setH:_lineChart.height * 1.855];
        }
        
        self.lineChart.yFixedValueMax = 1.5;
        self.lineChart.yFixedValueMin = 0;
        
        _lineChart.showLabel = NO;
    }
    return _lineChart;
}

#pragma mark - Private Methods -

- (void)_animationToPortraitRotationChartView {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineChart.frame = self.chartContentView.frame;
        [self _updateChart];
    }];
}

- (void)_animationToLandscapeRotationChartView {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineChart.frame = self.view.frame;
        [self.lineChart setX:0.f andY:0.f];
        [self _updateChart];
    }];
}

- (void)_updateInterface {
    self.title = self.viewModel.title;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorMes];
    self.weekLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoPorSemama];
    self.inLineLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.quantidadeConfirmacaoSeguidos];
    [self.doneButton setSelected:self.viewModel.isLembreteConfirmated];
    [self _updateChart];
}

- (void)_updateChart { 
    PNLineChartData *lineChartData = [PNLineChartData new];
    lineChartData.color = PNFreshGreen;
    lineChartData.itemCount = [self.viewModel chartDataItemCount];
//    lineChartData.inflexionPointStyle = PNLineChartPointStyleCircle;

    NSArray *calendario = self.viewModel.calendario;
    NSArray *lembretesConfirmados = self.viewModel.dataLembretesConfirmados;
    
    lineChartData.getData = ^(NSUInteger index) {
        NSUInteger valorY = 0;
        
        NSDate *data = [calendario objectAtIndex:index];
        if ([lembretesConfirmados containsObject:data]) {
            valorY = 1;
        }
        return [PNLineChartDataItem dataItemWithY:valorY];
    };
        
    self.lineChart.chartData = @[lineChartData];
    [self.lineChart setXLabels:[self.viewModel chartDataXLabels]];
    [self.lineChart strokeChart];
}

- (void)_presentNewReminderViewController {
    ADEditReminderViewController *newReminderViewController = [ADEditReminderViewController viewController];
    newReminderViewController.delegate = self;
    newReminderViewController.modalPresentationStyle = UIModalPresentationCustom;
    newReminderViewController.actionMode = ADEditMode;
    
    [newReminderViewController.viewModel LembreteEdit:[self.viewModel model]];
    
    [self presentViewController:newReminderViewController animated:YES completion:nil];
}

- (void)_IBOutletTitle {
    self.monthTitleLabel.text = NSLocalizedString(@"Mês", nil);
    self.weekTitleLabel.text = NSLocalizedString(@"Semana", nil);
    self.inLineTitleLabel.text = NSLocalizedString(@"Seguidos", nil);
    [self.doneButton setTitle:NSLocalizedString(@"Você lembrou?", nil) forState:UIControlStateNormal];
    [self.doneButton setTitle:[self _doneButtonTitles] forState:UIControlStateSelected];
}

- (NSString *)_doneButtonTitles {
    NSString *title = nil;
    
    NSArray *titles = @[
        NSLocalizedString(@"title1", nil),
        NSLocalizedString(@"title2", nil),
        NSLocalizedString(@"title3", nil),
        NSLocalizedString(@"title4", nil),
        NSLocalizedString(@"title5", nil)
    ];
    
    int index = arc4random() % titles.count;
    title = [titles objectAtIndex:index];    
    return title;
}

#pragma mark - IBAction Methods -

- (IBAction)editButtonTouched:(id)sender {
    [[GAI sharedInstance] sendAction:@"EditActivity" withCategory:@"Action"];
    [self _presentNewReminderViewController];
}

- (IBAction)doneButtonTouched:(id)sender {
    if (self.doneButton.selected) {
        [[GAI sharedInstance] sendAction:@"RememberQuestionActivity" withCategory:@"Action"];
        [self.viewModel removeLembreteConfirmado];
    } else {
        [[GAI sharedInstance] sendAction:@"RememberOkActivity" withCategory:@"Action"];
        [self.viewModel addLembreteConfirmado];
    }
    
    [self _updateInterface];
}

#pragma mark - ADEditReminderViewControllerDelegate Methods -

- (void)newReminderViewController:(ADEditReminderViewController *)newReminderViewController
                  didSaveReminder:(ADLembrete *)reminder {
    [newReminderViewController dismissViewControllerAnimated:YES completion:^{
        self.title = reminder.descricao;
    }];
}

- (void)newReminderViewControllerDidCancelReminder:(ADEditReminderViewController *)newReminderViewController {
}

#pragma mark - UIInterfaceOrientation Methods
//- (void)willRotateToInterfaceOrientation:(NSNotification *)notification {
//    UIDevice *device = notification.object;
//    
//    if (device.orientation == UIInterfaceOrientationPortrait ||
//        device.orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        [self performSelector:@selector(_animationToPortraitRotationChartView) withObject:self];
//    } else {
//        [self performSelector:@selector(_animationToLandscapeRotationChartView) withObject:self];
//    }
//}

@end
