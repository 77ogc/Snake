//
//  Snake.swift
//  alert
//
//  Created by 張永霖 on 2021/1/28.
//

import UIKit

enum Direction
{
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

class Snake {
    var head_x:CGFloat = 50
    var head_y:CGFloat = 50
    var direction:[Direction] = []
    var body:[UIView?] = []
    var body_x:[CGFloat] = []
    var body_y:[CGFloat] = []
    var head:UIView?
    var food_x:[CGFloat] = []
    var food_y:[CGFloat] = []
    var food:[UIView?] = []
    init() {
        head = UIView(frame: CGRect(x: head_x, y: head_y, width: 15, height: 15))
        head!.backgroundColor = .red
        body.append(head)
        body_x.append(head_x)
        body_y.append(head_y)
        direction.append(Direction.RIGHT)
    }
    deinit {
        head = nil
        for i in 0..<body.count {
            body[i]!.removeFromSuperview()
            body[i] = nil
            
        }
        for i in 0..<food.count {
            food[i]!.removeFromSuperview()
            food[i] = nil
        }
    }
}
