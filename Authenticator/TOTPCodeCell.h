//
//  TOTPCodeCell.h
//  Authenticator
//
//  Created by Eric Stern on 12/9/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOTPCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
