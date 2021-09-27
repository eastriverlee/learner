//
//  Shell.swift
//  learner
//
//  Created by dan lee on 2021/09/26.
//

import Foundation
import Darwin

@discardableResult
func shell(_ command: String) -> (status: Int32, output: [Byte]) {
	let task = Process()
	let pipe = Pipe()
	
	task.standardOutput = pipe
	task.standardError = pipe
	task.arguments = ["-c", command]
	task.launchPath = "/bin/zsh"
	task.launch()
	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	task.waitUntilExit()
	return (task.terminationStatus, Array(data))
}
