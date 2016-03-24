//
//  CoverFlowLayout.m
//  CoverFlowLayout
//
//  Created by Nelson Chow on 2016-03-24.
//  Copyright © 2016 Nelson Chow. All rights reserved.
//

#import "CoverFlowLayout.h"


@interface CoverFlowLayout ()
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

@end

@implementation CoverFlowLayout

static const float ZOOM_FACTOR = 0.25;

//- (void)prepareLayout {     // fill the array with attributes.
//    [super prepareLayout];
//
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.itemSize = CGSizeMake(100, 100);

    
//    NSMutableArray *temp = [NSMutableArray array];     // temp MArray.
//    
//    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
//        NSIndexPath *ip = [NSIndexPath indexPathForItem:item inSection:0];      // fill the array by iteration.
//        
//        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:ip];
//        
//        [temp addObject:attr];
//    }
//    
//    self.savedAttributes = temp;        // set savedAttributes as temp.
//}



-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //    NSLog(@"Returning attributes for elements in {(%f, %f),(%f, %f)}",
    //          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    float collectionViewHalfFrame = self.collectionView.frame.size.width/2.0;
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in attributes) {
        if (CGRectIntersectsRect(layoutAttributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - layoutAttributes.center.x;
            CGFloat normalizedDistance= distance / collectionViewHalfFrame;
            
            if (ABS(distance) < collectionViewHalfFrame) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1- ABS(normalizedDistance));
                CATransform3D rotationTransform = CATransform3DIdentity;
                rotationTransform = CATransform3DMakeRotation(normalizedDistance * M_PI_2 *0.8, 0.0f, 1.0f, 0.0f);
                CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);
                layoutAttributes.transform3D = CATransform3DConcat(zoomTransform, rotationTransform);
                layoutAttributes.zIndex = ABS(normalizedDistance) * 10.0f;
                CGFloat alpha = (1  - ABS(normalizedDistance)) + 0.1;
                if (alpha > 1.0f) alpha = 1.0f;
                layoutAttributes.alpha = alpha;
            }
            else
            {
                layoutAttributes.alpha = 0.0f;
            }
        }
    }
    
    return attributes;
}


//
//
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    
//    CGRect visibleRegion;
//    visibleRegion.origin = self.collectionView.contentOffset;
//    visibleRegion.size = self.collectionView.contentSize;
//    
//    
//    for (UICollectionViewLayoutAttributes* layoutAttribute in attributes) {
//        if (CGRectIntersectsRect(layoutAttribute.frame, rect)) {
//            CGFloat distanceFromCenter = fabs(CGRectGetMidX(visibleRegion) - layoutAttribute.center.x);
//            
//            CGFloat scaleFactor = 1.0 - (distanceFromCenter / 400.0f);
//            
//            layoutAttribute.transform3D = CATransform3DMakeScale(scaleFactor, scaleFactor, scaleFactor);
//        }
//    }
//        return attributes;
//}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
