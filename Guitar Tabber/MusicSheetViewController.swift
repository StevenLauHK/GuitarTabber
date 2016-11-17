//
//  MusicSheetViewController.swift
//  Guitar Tabber
//
//  Created by Frank Tong on 17/11/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class MusicSheetViewController: UIViewController {

    let basicY:Int = 80
    let basicX:Int = 10
    
    let toNext:Int = 40
    
    //textField
    
    @IBOutlet var a1: UITextField!
    @IBOutlet var a2: UITextField!
    @IBOutlet var a3: UITextField!
    @IBOutlet var a4: UITextField!
    @IBOutlet var a5: UITextField!
    @IBOutlet var a6: UITextField!
    @IBOutlet var b1: UITextField!
    @IBOutlet var b2: UITextField!
    @IBOutlet var b3: UITextField!
    @IBOutlet var b4: UITextField!
    @IBOutlet var b5: UITextField!
    @IBOutlet var b6: UITextField!
    
    var textA = Array<UITextField>()
    //var textB = Array<UITextField>()
    var selected1:Int = 0
    //var selected2:Int = 0
    
    //music sheet
    var rectPathArr = Array<UIBezierPath>()
    var shapeLayerArr = Array<CAShapeLayer>()
    var linePathArr = Array<UIBezierPath>()
    var lineLayerArr = Array<CAShapeLayer>()
    var barLinePathArr = Array<UIBezierPath>()
    var barLineLayerArr = Array<CAShapeLayer>()
    var musicLinePathArr = Array<UIBezierPath>()
    var musicLineLayerArr = Array<CAShapeLayer>()
    
    //beat and name
    var beat1:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    var beat2:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    var songName:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    
    var labelArr = Array<UILabel>()
    
    var data:[[Int]] = [
        [6,26,26,36,16,26,6,6,
         6,26,26,36,36,46,6,6,
         6,26,26,36,16,26,6,6,
         6,26,26,36,36,46,6,6,
         5,15,15,25,15,15,25,5,
         35,25,5,5,35,25,5,5,
         6,26,26,36,16,26,6,6,
         26,16,26,26,6,6,6,6,
         6,16,26,26,16,26,26,6,
         5,25,25,35,25,25,35,5,
         6,6,136,6,136,6,136,6,
         136,5,5,5,0,3,25,3],
        [0,500,300,400,300,500,0,0,
         0,500,300,400,0,200,0,0,
         0,500,300,400,300,500,0,0,
         0,500,300,400,0,200,0,0,
         0,500,300,500,500,300,500,0,
         600,500,0,0,900,800,0,0,
         0,500,300,400,300,500,0,0,
         900,700,700,500,0,0,0,0,
         7,707,1007,707,707,1007,707,7,
         0,1000,800,900,1000,800,900,0,
         0,0,40400,0,30300,0,20200,0,
         100,0,1,2,0,2,2,2]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSheet()
        nameAndBeat()
        setupTextField()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeValue(_ sender: UIButton) {
        var tempNewDataA:Int = 0
        var tempNewLocationA:Int = 0
        var tempNewDataB:Int = 0
        var tempNewLocationB:Int = 0
        
        for i in 0..<6 {
            if textA[i].text! != "" {
                if tempNewDataA == 0 {
                    tempNewDataA = Int(textA[i].text!)!
                    tempNewLocationA = i+1
                }
                else{
                    if(Int(textA[i].text!)!>10){
                        tempNewDataA = tempNewDataA*10 + Int(textA[i].text!)!
                    }
                    else{
                        tempNewDataA = tempNewDataA*100 + Int(textA[i].text!)!
                    }
                    tempNewLocationA = tempNewLocationA*10 + i + 1
                    
                }
            }
            //data for second music node
            if textA[i+6].text! != "" {
                if tempNewDataB == 0 {
                    tempNewDataB = Int(textA[i+6].text!)!
                    tempNewLocationB = i+1
                }
                else{
                    if(Int(textA[i+6].text!)!>10){
                        tempNewDataB = tempNewDataB*10 + Int(textA[i+6].text!)!
                    }
                    else{
                        tempNewDataB = tempNewDataB*100 + Int(textA[i+6].text!)!
                    }
                    //tempNewDataB = tempNewDataB*100 + Int(textB[i].text!)!
                    tempNewLocationB = tempNewLocationB*10 + i + 1
                    
                }
            }
            
        }
        
        print("\(tempNewDataA) in \(tempNewLocationA)")
        print("\(tempNewDataB) in \(tempNewLocationB)")
        data[0][selected1] = tempNewLocationA
        data[1][selected1] = tempNewDataA
        data[0][selected1+1] = tempNewLocationB
        data[1][selected1+1] = tempNewDataB
        updateMusicSheet(number: selected1)
        updateMusicSheet(number: selected1+1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func touchOnScreen(_ sender: UITapGestureRecognizer) {
        let currentX:Float = Float(sender.location(in: self.view).x)
        let currentY:Float = Float(sender.location(in: self.view).y)
        print("touch: \(currentX),\(currentY)")
        
        if(currentX>50 && currentY>80 && currentY<500 && currentX<350){
            let indexX:Int = Int((currentX-50)/300*8)
            let indexY:Int = Int((currentY-80)/420*6)
            print("col:\(indexX), row:\(indexY)")
            //print("\(data[0][indexY*16+indexX*2])  \(data[0][indexY*16+indexX*2+1])")
            //labelArr[indexY*16+indexX*2].text = "5\n5\n5\n5\n5\n5\n"
            selected1 = indexY*16+indexX*2
        }
        for index in 0..<2{
            var numberOfNode:Int = 0
            
            var data1:Int = data[0][selected1+index]
            var location:[Int] = [-1,-1,-1,-1,-1,-1]
            
            if data1 > 0 {
                numberOfNode = 1
                location[0] = data1%10
            }
            
            while !(data1==0) && data1>10{
                data1/=10
                location[numberOfNode] = data1%10
                numberOfNode += 1
            }
            
            var temp = data[1][selected1+index]
            var tempArr:[Int] = [-1,-1,-1,-1,-1,-1]
            for j in 0..<numberOfNode{
                tempArr[location[j]-1] = temp%100
                temp/=100
                
            }
            for i in 0..<6 {
                if tempArr[i] == (-1){
                    textA[i+6*index].text = ""
                }
                else{
                    textA[i+6*index].text = "\(tempArr[i])"
                }
                
            }
            
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func drawSheet(){
        for i in 0..<18 {
            rectPathArr.append(
                UIBezierPath(rect: CGRect(
                    origin: CGPoint(x: basicX, y: basicY+i*10+toNext*Int(i/3)),
                    size: CGSize(width: UIScreen.main.bounds.width-20, height: 30)))
                
            )
            shapeLayerArr.append(CAShapeLayer())
            shapeLayerArr[i].path = rectPathArr[i].cgPath
            shapeLayerArr[i].fillColor = UIColor.clear.cgColor
            shapeLayerArr[i].strokeColor = UIColor.black.cgColor
            shapeLayerArr[i].lineWidth = 1.0
            view.layer.addSublayer(shapeLayerArr[i])
            
        }
        
        
        for i in 0..<48 {
            linePathArr.append(
                UIBezierPath(rect: CGRect(
                    origin: CGPoint(x:  50+i%8*40, y: basicY+60+70*(i/8)),
                    size: CGSize(width: 20, height: 0.5)))
            )
            lineLayerArr.append(CAShapeLayer())
            lineLayerArr[i].path = linePathArr[i].cgPath
            lineLayerArr[i].fillColor = UIColor.clear.cgColor
            lineLayerArr[i].strokeColor = UIColor.black.cgColor
            lineLayerArr[i].lineWidth = 1.2
            view.layer.addSublayer(lineLayerArr[i])
            
        }
        
        
        
        for i in 0..<12 {
            barLinePathArr.append(
                UIBezierPath(rect: CGRect(
                    origin: CGPoint(x:  40+i%2*160, y: basicY+70*(i/2)),
                    size: CGSize(width: 0.2, height: 50)))
            )
            barLineLayerArr.append(CAShapeLayer())
            barLineLayerArr[i].path = barLinePathArr[i].cgPath
            barLineLayerArr[i].fillColor = UIColor.clear.cgColor
            barLineLayerArr[i].strokeColor = UIColor.black.cgColor
            barLineLayerArr[i].lineWidth = 0.6
            view.layer.addSublayer(barLineLayerArr[i])
            
        }
        
        
        for i in 0..<96 {
            var temp:Int = data[0][i]
            while !(temp==0) && temp>10{
                
                temp/=10
            }
            //print("\(temp)")
            
            if data[0][i] != 0 {
                musicLinePathArr.append(
                    UIBezierPath(rect: CGRect(
                        origin: CGPoint(x:  50+i%16*20, y: basicY+70*(i/16)+(temp-1)*10),
                        size: CGSize(width: 0.2, height: 10.0+Double(6-temp)*10.0))
                    )
                )
                musicLineLayerArr.append(CAShapeLayer())
                musicLineLayerArr[i].path = musicLinePathArr[i].cgPath
                musicLineLayerArr[i].fillColor = UIColor.clear.cgColor
                musicLineLayerArr[i].strokeColor = UIColor.black.cgColor
                musicLineLayerArr[i].lineWidth = 0.6
                view.layer.addSublayer(musicLineLayerArr[i])
            }
            else{
                musicLinePathArr.append(
                    UIBezierPath(rect: CGRect(
                        origin: CGPoint(x:  50+i%16*20, y: basicY+70*(i/16)),
                        size: CGSize(width: 0.0, height: 60)))
                )
                musicLineLayerArr.append(CAShapeLayer())
                musicLineLayerArr[i].path = musicLinePathArr[i].cgPath
                musicLineLayerArr[i].fillColor = UIColor.clear.cgColor
                musicLineLayerArr[i].strokeColor = UIColor.black.cgColor
                musicLineLayerArr[i].lineWidth = 0.0
                view.layer.addSublayer(musicLineLayerArr[i])
            }
            
        }
        
        
        //set data
        for i in 0..<96 {
            
            var numberOfNode:Int = 0
            
            var data1:Int = data[0][i]
            var location:[Int] = [-1,-1,-1,-1,-1,-1]
            
            if data1 > 0 {
                numberOfNode = 1
                location[0] = data1%10
            }
            
            while !(data1==0) && data1>10{
                data1/=10
                location[numberOfNode] = data1%10
                numberOfNode += 1
            }
            
            var temp = data[1][i]
            var tempArr:[Int] = [-1,-1,-1,-1,-1,-1]
            for j in 0..<numberOfNode{
                tempArr[location[j]-1] = temp%100
                temp/=100
                
            }
            
            labelArr.append(UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150)))
            labelArr[i].numberOfLines = 0
            labelArr[i].center = CGPoint(x: 50+20*(i%16), y: basicY+30+70*(i/16))  //70
            labelArr[i].textAlignment = .center
            var result:String = ""
            for i in tempArr{
                
                if i == (-1){
                    result += "\n"
                }
                else{
                    result += "\(i)\n"
                }
                
            }
            labelArr[i].text = result
            labelArr[i].font = UIFont.boldSystemFont(ofSize: 8.5)
            self.view.addSubview(labelArr[i])
        }
        
        
    }
    
    func nameAndBeat()  {
        
        beat1.numberOfLines = 0
        beat1.center = CGPoint(x: 25, y: 100)
        beat1.textAlignment = .center
        beat1.text = "4"
        beat1.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(beat1)
        
        beat2.numberOfLines = 0
        beat2.center = CGPoint(x: 25, y: 110)
        beat2.textAlignment = .center
        beat2.text = "4"
        beat2.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(beat2)
        songName.numberOfLines = 0
        songName.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 30)
        songName.textAlignment = .center
        songName.text = "Folk Blues in E"
        songName.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(songName)
    }
    func setupTextField(){
        textA.append(a1)
        textA.append(a2)
        textA.append(a3)
        textA.append(a4)
        textA.append(a5)
        textA.append(a6)
        textA.append(b1)
        textA.append(b2)
        textA.append(b3)
        textA.append(b4)
        textA.append(b5)
        textA.append(b6)
    }
    
    func updateMusicSheet(number:Int){
        var numberOfNode:Int = 0
        
        var data1:Int = data[0][number]
        var location:[Int] = [-1,-1,-1,-1,-1,-1]
        
        if data1 > 0 {
            numberOfNode = 1
            location[0] = data1%10
        }
        
        while !(data1==0) && data1>10{
            data1/=10
            location[numberOfNode] = data1%10
            numberOfNode += 1
        }
        
        var temp = data[1][number]
        var tempArr:[Int] = [-1,-1,-1,-1,-1,-1]
        for j in 0..<numberOfNode{
            tempArr[location[j]-1] = temp%100
            temp/=100
            
        }
        
        var result:String = ""
        for i in tempArr{
            
            if i == (-1){
                result += "\n"
            }
            else{
                result += "\(i)\n"
            }
            
        }
        labelArr[number].text = result
        
        var tempMax:Int = data[0][number]
        while !(tempMax==0) && tempMax>10{
            
            tempMax/=10
        }
        if data[0][number] != 0 {
            musicLinePathArr[number] = UIBezierPath(rect: CGRect(
                origin: CGPoint(x:  50+number%16*20, y: basicY+70*(number/16)+(tempMax-1)*10),
                size: CGSize(width: 0.2, height: 10.0+Double(6-tempMax)*10.0))
            )
            
            musicLineLayerArr[number].path = musicLinePathArr[number].cgPath
            musicLineLayerArr[number].lineWidth = 0.6
        }
        else{
            musicLinePathArr[number] =
                UIBezierPath(rect: CGRect(
                    origin: CGPoint(x:  50+number%16*20, y: basicY+70*(number/16)),
                    size: CGSize(width: 0.0, height: 60)))
            
            musicLineLayerArr[number].path = musicLinePathArr[number].cgPath
            musicLineLayerArr[number].lineWidth = 0.0
            
        }
        
    }


}
