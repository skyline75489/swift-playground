import Foundation
// GET Request

let url = "http://httpbin.org/get"
let para = ["Hello": "World"]

if let resp = Requests.get(url, payload: para) {
    let json = JSON(data: resp)
    println(json)
}

let url2 = "http://www.baidu.com"
if let resp = Requests.get(url2) {
    let r = NSString(data: resp, encoding: NSUTF8StringEncoding)
    println(r)
}