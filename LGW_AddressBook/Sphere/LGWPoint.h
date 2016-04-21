//
//  LGWPoint.h
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#ifndef sphereTagCloud_LGWPoint_h
#define sphereTagCloud_LGWPoint_h

struct LGWPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct LGWPoint LGWPoint;


LGWPoint LGWPointMake(CGFloat x, CGFloat y, CGFloat z) {
    LGWPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif
