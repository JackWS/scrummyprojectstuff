//
//  DataParser.h
//  Project40
//
//  Created by John Stack on 12/15/2011 on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "SQLManager.h"
#import "DDXML.h"


@interface DataParser : NSObject {

	NSMutableArray*			m_Projects;
	
	SQLManager*				m_SQLManager;
}

@property (nonatomic, retain) NSMutableArray* m_Projects;

- (id)init;

- (SQLManager*)getSQLManager;
- (NSMutableArray*)getProjects;

- (void)parseProjects;
- (void)loadProjects;


@end
