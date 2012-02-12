//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Atharv Vaish on 2/6/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([digit isEqualToString:@"."]) {
            if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        } else {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {
        if ([digit isEqualToString:@"."]) {
            self.display.text = [@"0" stringByAppendingString:digit];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        } else if ([digit isEqualToString:@"0"]) {
            self.display.text = digit;
        } else {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        
    }
}

- (IBAction)enterPressed
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    self.history.text = [NSString stringWithFormat:@"%@ %@", self.history.text, self.display.text];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed 
{
    self.history.text = @"";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clear];
}

- (IBAction)backspacePressed 
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    if (self.display.text.length > 0) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
    }
    if (self.display.text.length == 0 || [self.display.text isEqualToString:@"0"]) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([sender.currentTitle isEqualToString:@"+ / -"]) {
            if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
                self.display.text = [self.display.text substringFromIndex:1];
            } else {
                self.display.text = [@"-" stringByAppendingString:self.display.text];
            }
            return;
        }
        [self enterPressed];
    }
    self.history.text = [NSString stringWithFormat:@"%@ %@ =", self.history.text, sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    if ([resultString isEqualToString:@"-0"]) resultString = @"0";
    self.display.text = resultString;
}

@end
