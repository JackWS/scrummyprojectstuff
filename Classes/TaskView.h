//
//  TaskView.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on December 15, 2011.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ProjectView.h"


@interface TaskView : UIView {
	
	UILabel*				m_TitleLabel;
	UIImageView*			m_ImageView;
	
	BOOL					m_IsTaskViewType;
	
	MainViewController*		m_Parent;
	ProjectView*			m_ProjectView;
	
	Task*					m_Task;
	Milestone*				m_Milestone;
	
	BOOL					m_Highlight;
}

@property (nonatomic, retain) UILabel* m_TitleLabel;

- (id)initWithType:(BOOL)isTaskViewType;
- (void)setParent:(MainViewController*)parent prjView:(ProjectView*)prjView;
- (void)setParentForPickedView:(MainViewController*)parent prjView:(ProjectView*)prjView;

- (Task*)getTask;
- (void)setTask:(Task*)task;
- (Milestone*)getMilestone;
- (void)setMilestone:(Milestone*)milestone;

- (void)setTaskViewFrame:(CGRect)frame;

- (BOOL)isTaskViewType;
- (void)setTaskViewType:(BOOL)type;
- (ProjectView*)getProjectView;

- (void)setHighlighted:(BOOL)highlight;


@end
