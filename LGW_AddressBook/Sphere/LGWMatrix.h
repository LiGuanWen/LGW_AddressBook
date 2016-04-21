//
//  LGWMatrix.h
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#ifndef sphereTagCloud_LGWMatrix_h
#define sphereTagCloud_LGWMatrix_h

#import "LGWPoint.h"

struct LGWMatrix {
    NSInteger column;
    NSInteger row;
    CGFloat matrix[4][4];
};

typedef struct LGWMatrix LGWMatrix;

static LGWMatrix LGWMatrixMake(NSInteger column, NSInteger row) {
    LGWMatrix matrix;
    matrix.column = column;
    matrix.row = row;
    for(NSInteger i = 0; i < column; i++){
        for(NSInteger j = 0; j < row; j++){
            matrix.matrix[i][j] = 0;
        }
    }
    
    return matrix;
}

static LGWMatrix LGWMatrixMakeFromArray(NSInteger column, NSInteger row, CGFloat *data) {
    LGWMatrix matrix = LGWMatrixMake(column, row);
    for (int i = 0; i < column; i ++) {
        CGFloat *t = data + (i * row);
        for (int j = 0; j < row; j++) {
            matrix.matrix[i][j] = *(t + j);
        }
    }
    return matrix;
}

static LGWMatrix LGWMatrixMutiply(LGWMatrix a, LGWMatrix b) {
    LGWMatrix result = LGWMatrixMake(a.column, b.row);
    for(NSInteger i = 0; i < a.column; i ++){
        for(NSInteger j = 0; j < b.row; j ++){
            for(NSInteger k = 0; k < a.row; k++){
                result.matrix[i][j] += a.matrix[i][k] * b.matrix[k][j];
            }
        }
    }
    return result;
}

static LGWPoint LGWPointMakeRotation(LGWPoint point, LGWPoint direction, CGFloat angle) {
    //    CGFloat temp1[4] = {direction.x, direction.y, direction.z, 1};
    //    LGWMatrix directionM = LGWMatrixMakeFromArray(1, 4, temp1);
    if (angle == 0) {
        return point;
    }
    
    CGFloat temp2[1][4] = {point.x, point.y, point.z, 1};
    //    LGWMatrix pointM = LGWMatrixMakeFromArray(1, 4, *temp2);
    
    LGWMatrix result = LGWMatrixMakeFromArray(1, 4, *temp2);
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1[4][4] = {{1, 0, 0, 0}, {0, cos1, sin1, 0}, {0, -sin1, cos1, 0}, {0, 0, 0, 1}};
        LGWMatrix m1 = LGWMatrixMakeFromArray(4, 4, *t1);
        result = LGWMatrixMutiply(result, m1);
    }
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2[4][4] = {{cos2, 0, -sin2, 0}, {0, 1, 0, 0}, {sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        LGWMatrix m2 = LGWMatrixMakeFromArray(4, 4, *t2);
        result = LGWMatrixMutiply(result, m2);
    }
    
    CGFloat cos3 = cos(angle);
    CGFloat sin3 = sin(angle);
    CGFloat t3[4][4] = {{cos3, sin3, 0, 0}, {-sin3, cos3, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    LGWMatrix m3 = LGWMatrixMakeFromArray(4, 4, *t3);
    result = LGWMatrixMutiply(result, m3);
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2_[4][4] = {{cos2, 0, sin2, 0}, {0, 1, 0, 0}, {-sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        LGWMatrix m2_ = LGWMatrixMakeFromArray(4, 4, *t2_);
        result = LGWMatrixMutiply(result, m2_);
    }
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1_[4][4] = {{1, 0, 0, 0}, {0, cos1, -sin1, 0}, {0, sin1, cos1, 0}, {0, 0, 0, 1}};
        LGWMatrix m1_ = LGWMatrixMakeFromArray(4, 4, *t1_);
        result = LGWMatrixMutiply(result, m1_);
    }
    
    LGWPoint resultPoint = LGWPointMake(result.matrix[0][0], result.matrix[0][1], result.matrix[0][2]);
    
    return resultPoint;
}

#endif