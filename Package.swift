// swift-tools-version:4.1

import PackageDescription

let package = Package(name: "BillboardBot",
	dependencies: [
		.package(url: "https://github.com/SlackKit/SlackKit.git", from: "4.1.0"),
		.package(url: "https://github.com/FitzAfful/BillboardSwiftLibrary.git", from: "0.1.4")
	], targets: [
		 .target(name: "BillboardBot", dependencies: ["SlackKit","BillboardSwiftLibrary"], path: "." )
		]
	
)

