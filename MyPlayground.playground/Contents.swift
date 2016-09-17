//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

let a = str.substring(from: str.index(str.startIndex, offsetBy: 5))

let b = str.substring(to: str.index(str.startIndex, offsetBy: 5))

let d = ["1": "hello", "2": "play", "3": "ground"]

let e = [4,5,1,2,3,5]

print(d, e, separator: "|", terminator: "end")


class MyClass {
    init(name: String, age: Int) {

    }
}

