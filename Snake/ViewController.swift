//
//  ViewController.swift
//  alert
//
//  Created by 張永霖 on 2021/1/14.
//

import UIKit



class ViewController: UIViewController {

    var timer = Timer()
    var snake:Snake!
    var time_count:Int = 0
    var size:CGFloat = 15
    var refreshTime:Double = 0.15
    var stopFlag:Bool = true
    var restartButtom:UIButton!
    var stopButtom:UIButton!
    var path:UIBezierPath = UIBezierPath()
    var shapeLayer:CAShapeLayer = CAShapeLayer()
    var dieFlag:Bool = false
    

    //let head = SnakeBody(frame: CGRect(x: 50, y: 50, width: 20, height: 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        snake = Snake()
        self.background()
        
        view.addSubview(self.snake.head!)
        
        let upButtom = UIButton(frame: CGRect(x: (view.frame.size.width )/2 + 60 , y: (view.frame.size.height - 185), width: 60, height: 60))
        upButtom.setTitle("^", for: .normal)
        upButtom.setTitleColor(.white, for: .normal)
        upButtom.backgroundColor = .black
        upButtom.addTarget(self, action: #selector(Move), for: .touchUpInside)
        upButtom.tag = 10
        view.addSubview(upButtom)
        
        let downButtom = UIButton(frame: CGRect(x: (view.frame.size.width )/2 + 60, y: (view.frame.size.height - 65), width: 60, height: 60))
        downButtom.setTitle("v", for: .normal)
        downButtom.setTitleColor(.white, for: .normal)
        downButtom.backgroundColor = .black
        downButtom.addTarget(self, action: #selector(Move), for: .touchUpInside)
        downButtom.tag = 11
        view.addSubview(downButtom)
        
        let rightButtom = UIButton(frame: CGRect(x: (view.frame.size.width )/2 + 120, y: (view.frame.size.height - 125), width: 60, height: 60))
        rightButtom.setTitle(">", for: .normal)
        rightButtom.setTitleColor(.white, for: .normal)
        rightButtom.backgroundColor = .black
        rightButtom.addTarget(self, action: #selector(Move), for: .touchUpInside)
        rightButtom.tag = 12
        view.addSubview(rightButtom)
        
        let leftButtom = UIButton(frame: CGRect(x: (view.frame.size.width)/2 , y: (view.frame.size.height - 125), width: 60, height: 60))
        leftButtom.setTitle("<", for: .normal)
        leftButtom.setTitleColor(.white, for: .normal)
        leftButtom.backgroundColor = .black
        leftButtom.addTarget(self, action: #selector(Move), for: .touchUpInside)
        leftButtom.tag = 13
        view.addSubview(leftButtom)
        
        stopButtom = UIButton(frame: CGRect(x: (view.frame.size.width - 340 )/2, y: (view.frame.size.height - 130), width: 80, height: 50))
        stopButtom.setTitle("stop", for: .normal)
        stopButtom.setTitleColor(.white, for: .normal)
        stopButtom.backgroundColor = .black
        stopButtom.addTarget(self, action: #selector(Stop), for: .touchUpInside)
        stopButtom.tag = 14
        view.addSubview(stopButtom)
        
        restartButtom = UIButton(frame: CGRect(x: (view.frame.size.width - 340 )/2, y: (view.frame.size.height - 60), width: 80, height: 50))
        restartButtom.setTitle("restart", for: .normal)
        restartButtom.setTitleColor(.white, for: .normal)
        restartButtom.backgroundColor = .black
        restartButtom.addTarget(self, action: #selector(Restart), for: .touchUpInside)
        restartButtom.tag = 15
        view.addSubview(restartButtom)

        
        self.timer = Timer.scheduledTimer(timeInterval: refreshTime, target: self, selector: #selector(ViewController.Draw), userInfo: nil, repeats: true)
    }
    
    @objc func Restart() {
        snake = nil
        snake = Snake()
        view.addSubview(self.snake.head!)
        
    }
    
    @objc func Stop() {
        if(stopFlag)
        {
            timer.invalidate()
            stopFlag = false
            stopButtom.setTitle("resume", for: .normal)
            
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: refreshTime, target: self, selector: #selector(ViewController.Draw), userInfo: nil, repeats: true)
            stopFlag = true
            stopButtom.setTitle("stop", for: .normal)
        }
    }

    func food() {
        UIView.animate(withDuration: 0, animations: {
            let posx = CGFloat.random(in: 50..<self.view.frame.size.width - 50)
            let posy = CGFloat.random(in: 50..<self.view.frame.size.height - 230)
            self.snake.food_x.append(posx)
            self.snake.food_y.append(posy)
            let food = UIView(frame: CGRect(x: posx, y: posy, width: 15, height: 15))
            food.backgroundColor = .blue
            self.snake.food.append(food)
            self.view.addSubview(food)
            
        })
    }
    func eat() {
        for i in 0..<self.snake.food_x.count {
            if( abs(self.snake.body_x[0] - self.snake.food_x[i]) < 12 && abs(self.snake.body_y[0] - self.snake.food_y[i]) < 12 ) {
                self.addSnake()
                self.snake.food[i]!.removeFromSuperview()
                self.snake.food[i] = nil
                self.snake.food.remove(at: i)
                self.snake.food_x.remove(at: i)
                self.snake.food_y.remove(at: i)
                break
                
            }
        }
    }
    
    
    
    @objc func Draw() {
        UIView.animate(withDuration: 0.2, animations: {
            self.time_count += 1
            if(self.time_count % 10 == 0)
            {
                self.food()
                self.time_count = 0
            }
            self.eat()
            self.movingDirection()
            self.drawSnake()
            self.Die()
            
            //print("body : \(self.snake.body.count)")
            //print("body_x : \(self.snake.body_x.count)")

        })
    }
    
    func Die() {
        
        let alert = UIAlertController(title: "我好爛喔", message: "我真的好爛喔" , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "不然怎麼辦", style: .default, handler: nil)
        alert.addAction(alertAction)
        if(dieFlag)
        {
            present(alert, animated: true, completion: nil)
            self.Restart()
            self.Stop()
            dieFlag = false
        }
        if(self.snake.head_x < 15 || self.snake.head_x > view.frame.size.width - 30)
        {
            dieFlag = true;
        }
        else if(self.snake.head_y < 15 || self.snake.head_y > view.frame.size.height - 205)
        {
            dieFlag = true;
        }
        if(self.snake.body_x.count > 4){
            for i in 4..<self.snake.body_x.count {
                let x = self.snake.body_y[0]
                let y = self.snake.body_y[i]
                let a = self.snake.body_x[0]
                let b = self.snake.body_x[i]

                let ans1 = abs(x - y)
                let ans2 = abs(a - b)

                if(ans1 < 2 && ans2 < 2)
                {
                    dieFlag = true;
                }

                
            }
        }

    }
    
    func background(){
        path.move(to: CGPoint(x: 20, y: 20.0))
        path.addLine(to: CGPoint(x: 20.0, y: self.view.frame.size.height - 195))
        path.addLine(to: CGPoint(x: self.view.frame.size.width - 25, y: self.view.frame.size.height - 195))
        path.addLine(to: CGPoint(x: self.view.frame.size.width - 25, y: 20.0))
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = nil
        self.view.layer.addSublayer(shapeLayer)
  
    }
    
    func addSnake() {
        var posx:CGFloat = 0
        var posy:CGFloat = 0
        
        if(self.snake.direction[self.snake.body.count - 1] == Direction.UP)
        {
            posx = self.snake.body_x[self.snake.body.count - 1]
            posy = self.snake.body_y[self.snake.body.count - 1] + size
        }
        if(self.snake.direction[self.snake.body.count - 1] == Direction.DOWN)
        {
            posx = self.snake.body_x[self.snake.body.count - 1]
            posy = self.snake.body_y[self.snake.body.count - 1] - size
        }
        if(self.snake.direction[self.snake.body.count - 1] == Direction.RIGHT)
        {
            posx = self.snake.body_x[self.snake.body.count - 1] - size
            posy = self.snake.body_y[self.snake.body.count - 1]
        }
        if(self.snake.direction[self.snake.body.count - 1] == Direction.LEFT)
        {
            posx = self.snake.body_x[self.snake.body.count - 1] + size
            posy = self.snake.body_y[self.snake.body.count - 1]
        }
        
        let temp = UIView(frame: CGRect(x: posx, y: posy, width: size, height: size))
        temp.backgroundColor = .black
        self.snake.body.append(temp)
        self.snake.direction.append(self.snake.direction[self.snake.direction.count - 1])
        self.snake.body_x.append(posx)
        self.snake.body_y.append(posy)
        view.addSubview(temp)
        
    }
 
    
    func drawSnake() {
        for i in (0..<self.snake.body.count).reversed() {
            self.snake.body[i]!.frame = CGRect(x: self.snake.body_x[i], y: self.snake.body_y[i], width: size, height: size)
        }
        for i in (1..<self.snake.body.count).reversed() {
            self.snake.body_x[i] = self.snake.body_x[i-1]
            self.snake.body_y[i] = self.snake.body_y[i-1]
        }
    }

    func lookFrontSnake(i :Int)
    {
        if(i != 0)
        {
            //self.snake.direction[i] = self.snake.direction[i-1]
            
            if(self.snake.direction[i] == Direction.UP)
            {
                self.snake.body_x[i] = self.snake.body_x[i-1]
                self.snake.body_y[i] = self.snake.body_y[i-1]
            }
            if(self.snake.direction[i] == Direction.DOWN)
            {
                self.snake.body_x[i] = self.snake.body_x[i-1]
                self.snake.body_y[i] = self.snake.body_y[i-1]
            }
            if(self.snake.direction[i] == Direction.RIGHT)
            {
                self.snake.body_x[i] = self.snake.body_x[i-1]
                self.snake.body_y[i] = self.snake.body_y[i-1]
            }
            if(self.snake.direction[i] == Direction.LEFT)
            {
                self.snake.body_x[i] = self.snake.body_x[i-1]
                self.snake.body_y[i] = self.snake.body_y[i-1]
            }
            
            self.snake.direction[i] = self.snake.direction[i-1]
        }
    }
    
    func movingDirection(){
        if(self.snake.direction[0] == Direction.UP)
        {
            //if(self.snake.body_y[0] > 25)
            //{
                self.snake.body_y[0] = self.snake.body_y[0] - size
                self.snake.head_x = self.snake.body_x[0]
                self.snake.head_y = self.snake.body_y[0]
            //}
        }
        if(self.snake.direction[0] == Direction.DOWN)
        {
            //if(self.snake.body_y[0] < view.frame.size.height - 220)
            //{
                self.snake.body_y[0] = self.snake.body_y[0] + size
                self.snake.head_x = self.snake.body_x[0]
                self.snake.head_y = self.snake.body_y[0]
            //}
        }
        if(self.snake.direction[0] == Direction.RIGHT)
        {
            //if(self.snake.body_x[0] < view.frame.size.width - 45)
           // {
                self.snake.body_x[0] = self.snake.body_x[0] + size
                self.snake.head_x = self.snake.body_x[0]
                self.snake.head_y = self.snake.body_y[0]
            //}
        }
        if(self.snake.direction[0] == Direction.LEFT)
        {
            //if(self.snake.body_x[0] > 25)
            //{
                self.snake.body_x[0] = self.snake.body_x[0] - size
                self.snake.head_x = self.snake.body_x[0]
                self.snake.head_y = self.snake.body_y[0]
            //}
        }
    }
    
    @objc func Move( _ sender:UIButton) {
        if (sender.tag == 10)
        {
            if(self.snake.direction[0] != Direction.DOWN)
            {
                self.snake.direction[0] = Direction.UP
            }
        }
        if (sender.tag == 11)
        {
            if(self.snake.direction[0] != Direction.UP)
            {
                self.snake.direction[0] = Direction.DOWN
            }
        }
        if (sender.tag == 12)
        {
            if(self.snake.direction[0] != Direction.LEFT)
            {
                self.snake.direction[0] = Direction.RIGHT
            }
        }
        if (sender.tag == 13)
        {
            if(self.snake.direction[0] != Direction.RIGHT)
            {
                self.snake.direction[0] = Direction.LEFT
            }
        }
    }

    
}

