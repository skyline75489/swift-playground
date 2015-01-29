import Foundation


func isValid(s:String) -> Bool {
    let para_map = ["(":")",
                    "{":"}",
                    "[":"]"]
    var stack = Stack<String>()
    for ch in s {
        let top = String(ch)
        if (stack.count == 0) {
            stack.push(top)
            continue
        }
        if let p = para_map[stack.top()!] {
            if (p == top) {
                stack.pop()
            } else {
                stack.push(top)
            }
        } else {
            stack.push(top)
        }
    }
    return stack.count == 0
}

println(isValid("{}[()]"))