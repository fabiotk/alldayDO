//
//  ADEditReminderViewModel.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 14/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "ADEditReminderViewModel.h"

#import "ADModel.h"
#import "ADLocalNotification.h"

@interface ADEditReminderViewModel ()

@property (nonatomic, strong) ADLembrete *lembreteEdit;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerCategorias;

@end

@implementation ADEditReminderViewModel

#pragma mark - Getter Methods -

- (NSString *)descricaoEdit {
    return self.lembreteEdit.descricao;
}

- (NSDate *)dataEdit {
    return self.lembreteEdit.data;
}

- (NSDate *)dataInicialEdit {
    return self.lembreteEdit.dataInicial;
}

- (NSNumber *)periodoEdit {
    return self.lembreteEdit.periodo;
}

- (ADCategoria *)categoriaEdit {
    return self.lembreteEdit.categoria;
}

- (NSData *)imagemEdit {
    return self.lembreteEdit.imagem;
}

- (NSArray *)cycleType {
    return @[
        NSLocalizedString(@"Diariamente", nil),
        NSLocalizedString(@"Semanalmente", nil),
        NSLocalizedString(@"Mensalmente", nil),
        NSLocalizedString(@"Uma única vez", nil),
        NSLocalizedString(@"Nunca", nil)
    ];
}

- (NSArray *)categorias {
    [self.fetchedResultsControllerCategorias performFetch:nil];
    return [self.fetchedResultsControllerCategorias fetchedObjects];
}

- (NSArray *)lembretes {
    [self.fetchedResultsController performFetch:nil];
    return [self.fetchedResultsController fetchedObjects];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADLembrete"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"editReminders_cache"];
    }
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsControllerCategorias {
    if (!_fetchedResultsControllerCategorias) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ADCategoria"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        _fetchedResultsControllerCategorias = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                  managedObjectContext:[ADModel sharedInstance].managedObjectContext
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:@"categoria_cache"];
    }
    return _fetchedResultsControllerCategorias;
}

#pragma mark - Public Methods -

- (void)saveChanges {
    ADLembrete *lembrete = nil;
    if (self.lembreteEdit) {
        lembrete = self.lembreteEdit;
    } else {
        lembrete = [NSEntityDescription insertNewObjectForEntityADLembrete];
    }
    
    lembrete.descricao = self.descricao;
    lembrete.periodo = self.periodo;
    lembrete.data = self.data;
    lembrete.dataInicial = self.dataInicial;
    lembrete.categoria = self.categoria;
    lembrete.imagem = self.imagem;
    
    [[ADModel sharedInstance] saveChanges];
    [[ADLocalNotification sharedInstance] scheduleAllLocalNotification];
}

- (NSString *)textForCycleType:(NSInteger)cycleType {
    return [self.cycleType objectAtIndex:cycleType];
}

- (void)LembreteEdit:(ADLembrete *)lembrete {
    self.lembreteEdit = lembrete;
}

- (NSInteger)typeForCycleString:(NSString *)CycleType {
    NSInteger type;
    if ([CycleType isEqualToString:NSLocalizedString(@"Diariamente", nil)]) {
        type = 0;
    } else if ([CycleType isEqualToString:NSLocalizedString(@"Semanalmente", nil)]) {
        type = 1;
    } else if ([CycleType isEqualToString:NSLocalizedString(@"Mensalmente", nil)]) {
        type = 2;
    } else if ([CycleType isEqualToString:NSLocalizedString(@"Uma única vez", nil)]) {
        type = 3;
    } else if ([CycleType isEqualToString:NSLocalizedString(@"Nunca", nil)]) {
        type = 4;
    }
    return type;
}

@end
