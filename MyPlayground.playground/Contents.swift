//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

let a = str.substring(from: str.index(str.startIndex, offsetBy: 5))

let b = str.substring(to: str.index(str.startIndex, offsetBy: 5))


let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
hostView.backgroundColor = UIColor.blue
PlaygroundPage.current.liveView = hostView

hostView
