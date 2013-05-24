//
//  CNAppDelegate.m
//  CNSplitView Example
//
//  Created by Frank Gregor on 03.01.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"


@interface CNAppDelegate () {
    CNSplitViewToolbar *toolbar;
    BOOL useAnimations;
}
@end

@implementation CNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.secondView.text = @"A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.";
    self.secondView.textBoxWidth = 380;
    self.secondView.icon = [NSImage imageNamed:@"SplitLeaf-Icon"];
    self.secondView.iconVerticalOffset = 70;

    useAnimations = NO;
    toolbar = [[CNSplitViewToolbar alloc] init];

    CNSplitViewToolbarButton *button1 = [[CNSplitViewToolbarButton alloc] init];
    button1.imageTemplate = CNSplitViewToolbarButtonImageTemplateAdd;
    button1.keyEquivalent = @"n";
    button1.keyEquivalentModifierMask = NSCommandKeyMask;

    CNSplitViewToolbarButton *button2 = [[CNSplitViewToolbarButton alloc] init];
    button2.imageTemplate = CNSplitViewToolbarButtonImageTemplateRemove;

    CNSplitViewToolbarButton *button3 = [[CNSplitViewToolbarButton alloc] init];
    button3.imageTemplate = CNSplitViewToolbarButtonImageTemplateLockUnlocked;
    button3.imagePosition = NSImageRight;
    button3.title = @"Lock";

    CNSplitViewToolbarButton *button4 = [[CNSplitViewToolbarButton alloc] init];
    button4.imageTemplate = CNSplitViewToolbarButtonImageTemplateRefresh;
    button4.title = @"Refresh";

    NSMenu *contextMenu = [[NSMenu alloc] init];
    [contextMenu addItemWithTitle:@"Context Menu Item 1" action:@selector(contextMenuItemSelection:) keyEquivalent:@""];
    [contextMenu addItemWithTitle:@"Context Menu Item 2" action:@selector(contextMenuItemSelection:) keyEquivalent:@""];
    CNSplitViewToolbarButton *menuButton = [[CNSplitViewToolbarButton alloc] initWithContextMenu:contextMenu];
    menuButton.imageTemplate = CNSplitViewToolbarButtonImageTemplateAction;

    NSTextField *textField = [[NSTextField alloc] init];
    [textField setBezeled:YES];
    [textField setBezeled:NSTextFieldRoundedBezel];
    [textField setToolbarItemWidth:120.0];

    NSPopUpButton *popupButton = [[NSPopUpButton alloc] init];
    [popupButton setToolbarItemWidth:120];
    [popupButton addItemsWithTitles:@[ @"Foo...", @"Bar...", @"Yelly" ]];
    [[popupButton cell] setControlSize:NSSmallControlSize];

    NSSlider *slider = [[NSSlider alloc] init];
    [slider setToolbarItemWidth:120.0];
    [[slider cell] setControlSize:NSSmallControlSize];


    [toolbar addItem:button1 align:CNSplitViewToolbarItemAlignLeft];
    [toolbar addItem:button2 align:CNSplitViewToolbarItemAlignLeft];
    [toolbar addItem:menuButton align:CNSplitViewToolbarItemAlignRight];
    [toolbar addItem:button3 align:CNSplitViewToolbarItemAlignRight];
    [toolbar addItem:button4 align:CNSplitViewToolbarItemAlignRight];
    [toolbar addItem:popupButton align:CNSplitViewToolbarItemAlignLeft];

    self.splitView.delegate = self;
    self.splitView.toolbarDelegate = self;
    [self.splitView attachToolbar:toolbar toSubViewAtIndex:1 onEdge:CNSplitViewToolbarEdgeBottom];
}

- (void)awakeFromNib
{
}

- (void)contextMenuItemSelection:(id)sender
{
    CNLog(@"selected menu item: %@", [(NSMenuItem *)sender title]);
}

- (IBAction)showHideToolbarAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    [self.splitView showToolbarAnimated:useAnimations];
    else                                            [self.splitView hideToolbarAnimated:useAnimations];
}

- (IBAction)useAnimationsAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    useAnimations = YES;
    else                                            useAnimations = NO;
}

- (IBAction)enableDisableToolbarItemsAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    [toolbar disable];
    else                                            [toolbar enable];
}

- (IBAction)enableDisableToolbarItemsDelimiterAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    toolbar.itemDelimiterEnabled = NO;
    else                                            toolbar.itemDelimiterEnabled = YES;
}

- (IBAction)centerToolbarItemsAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    toolbar.contentAlign = CNSplitViewToolbarContentAlignCentered;
    else                                            toolbar.contentAlign = CNSplitViewToolbarContentAlignItemDirected;
}

- (IBAction)draggingHandleEnabledAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState)    self.splitView.draggingHandleEnabled = YES;
    else                                            self.splitView.draggingHandleEnabled = NO;
}

- (IBAction)splitViewOrientationAction:(id)sender
{
    switch ([self.splitViewOrientationPopUp indexOfSelectedItem]) {
        case CNSplitViewDeviderOrientationVertical: {
            [self.splitView setVertical:YES];
            break;
        }
        case CNSplitViewDeviderOrientationHorizontal: {
            [self.splitView setVertical:NO];
            break;
        }
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
    return 180;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
{
    return [[[self window] contentView] bounds].size.width - 180;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CNSplitView Delegate

- (void)splitView:(CNSplitView *)theSplitView willShowToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:willShowToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView didShowToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:didShowToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView willHideToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:willHideToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView didHideToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:didHideToolbar:onEdge:");
}

@end
