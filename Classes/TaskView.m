//
//  TaskView.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on December 15, 2011.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "TaskView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TaskView

@synthesize m_TitleLabel;

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
	}
	return self;
}

- (id)initWithType:(BOOL)isTaskViewType {
	self = [super init];
	if (self) {
		m_IsTaskViewType = isTaskViewType;
		
	}
	return self;
}

- (void)setParent:(MainViewController*)parent prjView:(ProjectView*)prjView {
	m_Parent = parent;
	m_ProjectView = prjView;
	
	[m_Parent addGestureRecognizersToPiece:self];
}

- (void)setParentForPickedView:(MainViewController*)parent prjView:(ProjectView*)prjView {
	m_Parent = parent;
	m_ProjectView = prjView;
}

- (Task*)getTask {
	return m_Task;
}

- (void)setTask:(Task*)task {
	m_Task = task;
}

- (Milestone*)getMilestone {
	return m_Milestone;
}

- (void)setMilestone:(Milestone*)milestone {
	m_Milestone = milestone;
}

- (void)setTaskViewFrame:(CGRect)frame {
	
	// JBB Test
	self.alpha = 0.5;
	
	self.frame = frame;
	self.layer.borderColor = [[UIColor blackColor] CGColor];
	self.layer.borderWidth = 2.0;
	if (m_IsTaskViewType) {
		self.layer.cornerRadius = 10.0;
		
		CGRect titleLabelFrame = CGRectMake(8.0, 0.0, TaskButton_Width - 8.0, TaskButton_Height);
		if (self.m_TitleLabel == nil) {
			self.m_TitleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
			[self addSubview:self.m_TitleLabel];
		} else {
			self.m_TitleLabel.frame = titleLabelFrame;
		}
		
		NSString* buttonTitle = [NSString stringWithFormat:@"%@\n%d Minutes", [m_Task getTaskName], [m_Task getTaskDuration]];
		self.m_TitleLabel.text = buttonTitle;
		self.m_TitleLabel.textColor = [UIColor blackColor];
		self.m_TitleLabel.backgroundColor = [UIColor clearColor];
		self.m_TitleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		self.m_TitleLabel.textAlignment = UITextAlignmentCenter;
		self.m_TitleLabel.numberOfLines = 0;
		
		/*
		NSArray* subViews = [self subviews];
		for (UIView* subView in subViews)
			[subView removeFromSuperview];
		[self addSubview:self.m_TitleLabel];
		*/
		
		if (m_ImageView == nil) {
			m_ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dashed.png"]];
			m_ImageView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
			m_ImageView.userInteractionEnabled = NO;
			[self addSubview:m_ImageView];
		}
		
		[self setHighlighted:NO];
		
		NSString* searchKey = m_Parent.m_SearchField.text;
		if (searchKey != nil && searchKey.length > 0) {
			
			NSString* taskName = [m_Task getTaskName];
			if (taskName != nil && [[taskName lowercaseString] rangeOfString:[searchKey lowercaseString]].length > 0)
				[self setHighlighted:YES];
		}
	} else {
		self.layer.cornerRadius = 0.0;
		if (self.m_TitleLabel != nil)
			self.m_TitleLabel.frame = CGRectZero;
	}
}

- (BOOL)isTaskViewType {
	return m_IsTaskViewType;
}

- (void)setTaskViewType:(BOOL)type {
	m_IsTaskViewType = type;
}

- (ProjectView*)getProjectView {
	return m_ProjectView;
}

- (void)setHighlighted:(BOOL)highlight {
	
	if (!m_IsTaskViewType)
		return;
	
	m_Highlight = highlight;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	
	if (m_Highlight) {
		self.layer.borderColor = [[UIColor clearColor] CGColor];
		self.layer.borderWidth = 0.0;
		
		m_ImageView.hidden = NO;
		self.alpha = 1.0;
		//m_ImageView.alpha = 1.0;
	} else {
		self.layer.borderColor = [[UIColor blackColor] CGColor];
		self.layer.borderWidth = 2.0;
		
		m_ImageView.hidden = YES;
		self.alpha = 0.5;
		//m_ImageView.alpha = 0.0;
	}
	
	[UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[self.m_TitleLabel release];
	[m_ImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark methods related touches

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//[m_Parent hidePickedView];
	
	[m_Parent setPickedView:self];
	[m_ProjectView.m_WrapperView setScrollEnabled:NO];
	[m_Parent touchesBegan:touches withEvent:event];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesMoved:touches withEvent:event];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesEnded:touches withEvent:event];
	[m_ProjectView.m_WrapperView setScrollEnabled:YES];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesCancelled:touches withEvent:event];
	[m_ProjectView.m_WrapperView setScrollEnabled:YES];
}
*/


@end
