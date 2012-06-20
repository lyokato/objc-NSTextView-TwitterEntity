#import "NSTextView+TwitterEntity.h"
#import "TwitterText.h"

@implementation NSTextView (TwitterEntity)

- (void)setTwitterText:(NSString *)text
{
    NSUInteger lastLocation = 0;
    NSMutableDictionary *attr;
    NSAttributedString *attrString;
    NSString *tmp;

    // reset
    [self setString:@""];

    NSArray *entities = [TwitterText entitiesInText:text];
    
    for (TwitterTextEntity *entity in entities) {

        if (entity.range.location > lastLocation) {

            tmp = [text substringWithRange:NSMakeRange(lastLocation, entity.range.location - lastLocation)];
            
            attrString = [[NSAttributedString alloc] initWithString:tmp];
            [[self textStorage] appendAttributedString:attrString];
            [attrString release];
        }
         
        lastLocation = entity.range.location + entity.range.length;
        
        tmp = [text substringWithRange:entity.range];

        attr = [NSMutableDictionary dictionaryWithCapacity:2];
        [attr setObject:tmp forKey:NSLinkAttributeName];
        [attr setObject:[NSNumber numberWithInt:entity.type] forKey:@"EntityType"];
        
        /*
        switch (entity.type) {
            case TwitterTextEntityURL:
                break;
            case TwitterTextEntityScreenName:
                break;
            case TwitterTextEntityHashtag:
                break;
            case TwitterTextEntityListName:
                break;
            case TwitterTextEntityCashtag:
                break;
            default:
                break;
        }
        */
        
        attrString = [[NSAttributedString alloc] initWithString:tmp
                                                     attributes:attr];
        [[self textStorage] appendAttributedString:attrString];
        [attrString release];
    }
    
    if ([text length] > lastLocation) {
        tmp = [text substringFromIndex:lastLocation];
        attrString = [[NSAttributedString alloc] initWithString:tmp];
        [[self textStorage] appendAttributedString:attrString];
        [attrString release];
    }
}

@end
