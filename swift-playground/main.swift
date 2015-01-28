import Foundation

let s = "{\"C2051\" : [\"JU Yamaguchi\"],\"C2086\" : [\"USS Saitama\"]}"

let json = JSON(data:s.dataUsingEncoding(NSUTF8StringEncoding)!)


println(json)

let a = "www.stackoverflow.com"
println(a.lastIndexOf("."))
println(a.subString(0, length: 6))