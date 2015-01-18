// GET Request

let url = "http://httpbin.org/get"
let para = ["Hello": "World"]

if let resp = Requests.get(url, payload: para) {
    let json = JSON(data: resp)
    println(json)
}
