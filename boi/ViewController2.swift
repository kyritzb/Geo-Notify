//
//  ViewController2.swift
//  boi
//
//  Created by Bryan Kyritz on 10/17/18.
//  Copyright © 2018 Bryan Kyritz. All rights reserved.
//

import UIKit

class ViewController2 : UIViewController
{

    @IBOutlet weak var lblEquation: UILabel!
    @IBOutlet weak var lblNum: UILabel!
    
    var currentNum = ""
    var savedFirstNum = 0.0
    var operation = ""
    var equationText = ""
    var isNegated = false
    var hasClickedEquals = false
    var lastanswer = 0.0
    
    @IBAction func goToMap(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "mapSegue", sender: self)
    }
    @IBAction func zeroButton(_ sender: UIButton)
    {
        currentNum += "0"
        updateLabel()
    }
    @IBAction func oneButton(_ sender: UIButton)
    {
        currentNum += "1"
        updateLabel()
    }
    @IBAction func twoButton(_ sender: UIButton)
    {
        currentNum += "2"
        updateLabel()
    }
    @IBAction func threeButton(_ sender: UIButton)
    {
        currentNum += "3"
        updateLabel()
    }
    @IBAction func fourButton(_ sender: UIButton)
    {
        currentNum += "4"
        updateLabel()
    }
    @IBAction func fiveButton(_ sender: UIButton)
    {
        currentNum += "5"
        updateLabel()
    }
    @IBAction func sixButton(_ sender: UIButton)
    {
        currentNum += "6"
        updateLabel()
    }
    @IBAction func sevenButton(_ sender: UIButton)
    {
        currentNum += "7"
        updateLabel()
    }
    @IBAction func eightButton(_ sender: UIButton)
    {
        currentNum += "8"
        updateLabel()
    }
    @IBAction func nineButton(_ sender: UIButton)
    {
        currentNum += "9"
        updateLabel()
    }
    
    @IBAction func negateButton(_ sender: UIButton)
    {
        if(!isNegated)
        {
            isNegated = true
            currentNum = "-" + currentNum
        }
        else
        {
            isNegated = false
            currentNum.remove(at: currentNum.startIndex)
        }
        updateLabel()
    }
    @IBAction func ACButton(_ sender: UIButton)
    {
        resetCalc()
    }
    
    @IBAction func decimalButton(_ sender: UIButton)
    {
        currentNum += "."
        updateLabel()
    }
    @IBAction func answerButton(_ sender: UIButton)
    {
        currentNum += String(lastanswer)
        updateLabel()
    }
    @IBAction func plusButton(_ sender: UIButton)
    {
        if(operation == "")
        {
            savedFirstNum = Double(currentNum)!
            equationText += currentNum + "+" + operation
        }
        operation = "+"
        currentNum = ""
    }
    @IBAction func subtractionButton(_ sender: UIButton)
    {
        if(operation == "")
        {
            savedFirstNum = Double(currentNum)!
            equationText += currentNum + "-" + operation
        }
        operation = "-"
        currentNum = ""
    }
    @IBAction func multiplyButton(_ sender: UIButton)
    {
        if(operation == "")
        {
            savedFirstNum = Double(currentNum)!
            equationText += currentNum + "*" + operation
        }
        operation = "*"
        currentNum = ""
    }
    @IBAction func divisionButton(_ sender: UIButton)
    {
        if(operation == "")
        {
            savedFirstNum = Double(currentNum)!
            equationText += currentNum + "/" + operation
        }
        operation = "/"
        currentNum = ""
    }
    @IBAction func equalsButton(_ sender: UIButton)
    {
        var answer = 0.0
        if(operation == "+")
        {
            answer = savedFirstNum + Double(currentNum)!
        }
        else if(operation == "-")
        {
            answer = savedFirstNum - Double(currentNum)!
        }
        else if(operation == "/")
        {
            answer = savedFirstNum / Double(currentNum)!
        }
        else if(operation == "*")
        {
            answer = savedFirstNum * Double(currentNum)!
            
        }
        if(String(answer) == "0")
        {
            var answerSub = String(answer)
            answerSub.remove(at: answerSub.endIndex)
            answerSub.remove(at: answerSub.endIndex)
            lblEquation.text = equationText + currentNum + "=" + answerSub
        }
        else
        {
            lblEquation.text = equationText + currentNum + "=" + String(answer)
        }
        lastanswer = answer
        lblNum.text = ""
        resetCalc()
    }
    func resetCalc()
    {
        currentNum = ""
        savedFirstNum = 0.0
        operation = ""
        equationText = ""
        isNegated = false
        lblNum.text = ""
    }
    func updateLabel()
    {
        lblNum.text = currentNum
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resetCalc()
    }
}
