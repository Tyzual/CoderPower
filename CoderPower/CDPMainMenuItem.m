//
//  CDPMainMenuItem.m
//  CoderPower
//
//  Created by Dawn on 15/11/30.
//  Copyright © 2015年 Dawn. All rights reserved.
//

#import "CDPMainMenuItem.h"
#import "Defination.h"
#import "CDPUserInfoManager.h"

@interface CDPMainMenuItem ()

@property(nonatomic, retain) NSMenuItem *shake;
@property(nonatomic, retain) NSMenuItem *spark;
@property(nonatomic, retain) NSMenuItem *version;
@property(nonatomic, retain) NSMenuItem *clrCar;
@property(nonatomic, retain) NSMenuItem *clrSche;
@property(nonatomic, retain) NSMenuItem *constantCount;
@property(nonatomic, retain) NSMenuItem *comboCount;

@end

@implementation CDPMainMenuItem

+ (instancetype)item {
    CDPMainMenuItem *menuItem = [[CDPMainMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"CoderPower(%@)", CDPAppVersion] action:nil keyEquivalent:@""];

    if (menuItem) {
        NSMenu *mainMenu = [[[NSMenu alloc] initWithTitle:@"CoderPower"] autorelease];
        mainMenu.autoenablesItems = NO;
        menuItem.submenu = mainMenu;

        // shake item
        NSMenuItem *switchItem = [[[NSMenuItem alloc] initWithTitle:@"Disable Shake" action:@selector(shakeItemClick:) keyEquivalent:@""] autorelease];
        switchItem.target = menuItem;
        [mainMenu addItem:switchItem];
        menuItem.shake = switchItem;

		// buble
		NSMenuItem *sparkItem = [[[NSMenuItem alloc] initWithTitle:@"Disable Spark" action:@selector(sparkItemClick:) keyEquivalent:@""] autorelease];
		sparkItem.target = menuItem;
		[mainMenu addItem:sparkItem];
		menuItem.spark = sparkItem;

		// color
		NSMenuItem *colorItem = [[[NSMenuItem alloc] initWithTitle:@"Spark Colors" action:nil keyEquivalent:@""] autorelease];
		colorItem.enabled = YES;

		NSMenu *colorSubMenu = [[[NSMenu alloc] initWithTitle:@"color"] autorelease];
		colorSubMenu.autoenablesItems = NO;
		[colorSubMenu setAccessibilityEnabled:NO];

		colorItem.submenu = colorSubMenu;

		NSMenuItem *colorAtCaret = [[[NSMenuItem alloc] initWithTitle:@"At Caret" action:@selector(colorAtCaret:) keyEquivalent:@""] autorelease];
		NSMenuItem *colorInScheme = [[[NSMenuItem alloc] initWithTitle:@"Color In Current Colorscheme" action:@selector(colorInScheme:) keyEquivalent:@""] autorelease];

		colorAtCaret.target = menuItem;
		colorInScheme.target = menuItem;
		menuItem.clrCar = colorAtCaret;
		menuItem.clrSche = colorInScheme;
		[colorAtCaret setEnabled:YES];
		[colorInScheme setEnabled:YES];

		[colorSubMenu addItem:colorAtCaret];
		[colorSubMenu addItem:colorInScheme];
		[mainMenu addItem:colorItem];
		
		// count
		NSMenuItem *countItem = [[[NSMenuItem alloc] initWithTitle:@"Spark Count" action:nil keyEquivalent:@""] autorelease];
		countItem.enabled = YES;
		
		NSMenu *countSubMenu = [[[NSMenu alloc] initWithTitle:@"count"] autorelease];
		countSubMenu.autoenablesItems = NO;
		[colorSubMenu setAccessibilityEnabled:NO];
		
		countItem.submenu = countSubMenu;
		
		NSMenuItem *constantCount = [[[NSMenuItem alloc] initWithTitle:@"Constant" action:@selector(constantCount:) keyEquivalent:@""] autorelease];
		NSMenuItem *comboCount = [[[NSMenuItem alloc] initWithTitle:@"Combo" action:@selector(comboCount:) keyEquivalent:@""] autorelease];
		
		constantCount.target = menuItem;
		comboCount.target = menuItem;
		menuItem.constantCount = constantCount;
		menuItem.comboCount = comboCount;
		[constantCount setEnabled:YES];
		[comboCount setEnabled:YES];
		
		[countSubMenu addItem:constantCount];
		[countSubMenu addItem:comboCount];
		[mainMenu addItem:countItem];

		// version
		NSMenuItem *versionItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"version %@", CDPAppVersion] action:nil keyEquivalent:@""];
		versionItem.enabled = NO;
		[mainMenu addItem:versionItem];
		menuItem.version = versionItem;

		[menuItem updateTitles];

    }
    return [menuItem autorelease];
}

- (void)dealloc
{
    self.shake = nil;
	self.spark = nil;
    [super dealloc];
}

#pragma mark -

- (void)updateTitles {
    if (CDPUserInfoManager.isShakeOn) {
        self.shake.title = @"Disable Shake";
    } else {
        self.shake.title = @"Enable Shake";
    }

	if (CDPUserInfoManager.isSparkOn) {
		self.spark.title = @"Disable Spark";
	} else {
		self.spark.title = @"Enable Spark";
	}

	self.clrCar.state = 0;
	self.clrSche.state = 0;
	self.constantCount.state = 0;
	self.comboCount.state = 0;
	if (CDPUserInfoManager.isSparkOn) {
		[self updateColorSubMenu];
		[self updateCountSubMenu];
	} else {
		[self.clrCar setEnabled:NO];
		[self.clrSche setEnabled:NO];
		[self.constantCount setEnabled:NO];
		[self.comboCount setEnabled:NO];
	}
}

- (void)updateColorSubMenu {
	[self.clrCar setEnabled:YES];
	[self.clrSche setEnabled:YES];
	switch ([CDPUserInfoManager getClr]) {
		case clrCrt:
			self.clrCar.state = 1;
			break;
		case clrSch:
			self.clrSche.state = 1;
			break;
		default:
			break;
	}
}

- (void)updateCountSubMenu {
	[self.constantCount setEnabled:YES];
	[self.comboCount setEnabled:YES];
	switch ([CDPUserInfoManager getCountMode]) {
		case constantModeCount:
			self.constantCount.state = 1;
			break;
		case comboModeCount:
			self.comboCount.state = 1;
			break;
		default:
			break;
	}
}

- (void)shakeItemClick:(id)sender {
    CDPUserInfoManager.isShakeOn = !CDPUserInfoManager.isShakeOn;
    [self updateTitles];
}

- (void)sparkItemClick:(id)sender {
	CDPUserInfoManager.isSparkOn = !CDPUserInfoManager.isSparkOn;
	[self updateTitles];
}

- (void)colorAtCaret:(id)sender {
	[CDPUserInfoManager setClr:clrCrt];
	[self updateTitles];
}

- (void)colorInScheme:(id)sender {
	[CDPUserInfoManager setClr:clrSch];
	[self updateTitles];
}

- (void)constantCount:(id)sender {
	[CDPUserInfoManager setCountMode:constantModeCount];
	[self updateTitles];
}

- (void)comboCount:(id)sender {
	[CDPUserInfoManager setCountMode:comboModeCount];
	[self updateTitles];
}

@end
