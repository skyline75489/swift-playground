import PackageDescription

let package = Package(
    name: "swift-playground",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4)
    ]
)

