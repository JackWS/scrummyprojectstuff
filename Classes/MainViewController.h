//
//  MainViewController.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 12/15/2011
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "inc.h"

@class ProjectView;
@class TaskView;

@interface MainViewController : UIViewController <UITabBarDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate> {

	UIScrollView*			m_ScrollView;
	UITextField*			m_SearchField;
	UITabBar*				m_TabBar;
	UIButton*				m_MilestoneButton;
	
	int						m_SelectedProjectIndex;
	NSMutableArray*			m_ProjectList;
	NSMutableArray*			m_ProjectViewList;
	
	
	TaskView*				m_PickedView;
	
	CGRect					m_ContentViewFrame;
	CGFloat					m_XOffset;
	CGFloat					m_YOffset;
	
	
    UIView*					pieceForReset;
	CGPoint					m_Position;
	
	BOOL					m_WillDelete;
	BOOL					m_IsMoved;
	
	BOOL					m_IsVertical;
}

@property (nonatomic, retain) IBOutlet UIScrollView* m_ScrollView;
@property (nonatomic, retain) IBOutlet UITextField* m_SearchField;
@property (nonatomic, retain) IBOutlet UITabBar* m_TabBar;
@property (nonatomic, retain) IBOutlet UIButton* m_MilestoneButton;
@property (nonatomic, retain) NSMutableArray* m_ProjectList;
@property (nonatomic, retain) NSMutableArray* m_ProjectViewList;

@property (nonatomic, retain) IBOutlet TaskView* m_PickedView;


- (BOOL)isVertical;
- (BOOL)isMovedTaskView;
- (void)setMovedTaskView:(BOOL)moved;

- (void)reloadMainView;
- (void)setCellBackground:(int)projectIndex;
- (void)showMilestoneButton;
- (void)hideMilestoneButton;

- (void)setPickedView:(TaskView*)pickedView;
- (void)hidePickedView;

- (void)processTaskMove:(CGPoint)position;
- (void)processTaskCopy:(CGPoint)position;


- (void)addGestureRecognizersToPiece:(UIView *)piece;



-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIView *)theView;
-(void)animateView:(UIView *)theView toPosition:(CGPoint) thePosition;
-(void)animateHideView:(UIView *)theView toPosition:(CGPoint)thePosition;
-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event tapCount:(int)tCount;
-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)dispatchTouchCancelEvent:(UIView *)theView toPosition:(CGPoint)position;

- (void)textFieldDidChange:(UITextField*)sender;

@end
