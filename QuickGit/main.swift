#!/usr/bin/swift
import Foundation

let curentDirectory = FileManager.default.currentDirectoryPath

let arguments = CommandLine.arguments
var language: String?
var remoteRepo: String?

@discardableResult
func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

func initAndCommit(args: String?...) {
  var gitignoreText: String? = nil
  language = args[0]
  remoteRepo = args[1]
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
}

func quickCommit(commitMessage: String) {
  shell("git", "add", "-A")
  shell("git", "commit", "-m", "\(commitMessage)")
  shell("git", "push", "origin", "master")
}

switch arguments.count {
case 2:
  initAndCommit(args: arguments[1])
case 3:
  if arguments[1] == "commit" {
    quickCommit(commitMessage: arguments[2])
  } else {
    initAndCommit(args: arguments[1], arguments[2])
  }
default:
  break
}








