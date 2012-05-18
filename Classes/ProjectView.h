//
//  ProjectView.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on December 15, 2011.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "MainViewController.h"


@interface ProjectView : UIView {
	
	UIButton*				m_TitleButton;
	UIScrollView*			m_WrapperView;
	
	int						m_ProjectIndex;
	MainViewController*		m_Parent;
	
	NSMutableArray*			m_TaskViewList;
	NSMutableArray*			m_MilestoneViewList;
}

@property (nonatomic, retain) IBOutlet UIButton* m_TitleButton;
@property (nonatomic, retain) IBOutlet UIScrollView* m_WrapperView;
@property (nonatomic, retain) NSMutableArray* m_TaskViewList;
@property (nonatomic, retain) NSMutableArray* m_MilestoneViewList;

- (IBAction)tapProject;
- (void)setParent:(MainViewController*)parent;
//- (void)loadProjectInfo:(Project*)project;
- (void)reloadProjectView:(Project*)project prjIndex:(int)projectIndex vertical:(BOOL)vertical;

- (void)addTaskWith:(TaskView*)taskView addTaskOrder:(int)taskOrder;
- (TaskView*)deleteTaskWith:(TaskView*)taskView addTaskOrder:(int)taskOrder;


@end
