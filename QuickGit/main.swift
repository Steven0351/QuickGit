#!/usr/bin/swift
import Foundation

let curentDirectory = FileManager.default.currentDirectoryPath

let arguments = CommandLine.arguments
let language: String?
var remoteRepo: String?

switch arguments.count {
case 2:
  language = arguments[1]
case 3:
  language = arguments[1]
  remoteRepo = arguments[2]
default:
  language = nil
  remoteRepo = nil
}

var gitignoreText: String? = nil

if let language = language {
  switch language.lowercased() {
  case "swift", "objective-c", "objc", "xcode":
    gitignoreText = GitIgnoreText.swiftAndObjC.rawValue
  case "java", "kotlin", "android":
    gitignoreText = GitIgnoreText.android.rawValue
  default:
    break
  }
} else {
  gitignoreText = GitIgnoreText.swiftAndObjC.rawValue
}



@discardableResult
func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

let gitignoreURL = URL(fileURLWithPath: "\(curentDirectory)/.gitignore")

try! gitignoreText?.write(to: gitignoreURL, atomically: true, encoding: .ascii)

shell("git", "init")
shell("git", "add", "-A")
shell("git", "commit", "-m", "\"Initial commit with .gitignore\"")

guard let remoteRepo = remoteRepo else {
  exit(0)
}

shell("git", "remote", "add", "origin", remoteRepo)
shell("git", "push", "origin", "master")


