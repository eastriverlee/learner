//
//  ContentView.swift
//  Shared
//
//  Created by dan lee on 2021/09/15.
//

import Foundation
import SwiftUI

func arange(from start: Scalar, to end: Scalar, by step: Scalar = 0.1) -> [Scalar] {
	Array(stride(from: start, to: end, by: step))
}

func SinCos() -> some View {
	let x = arange(from: 0, to: 6, by: 0.1)
	let y1 = sin(x)
	let y2 = cos(x)
	
	return ZStack {
		Plotter(x, y1).foregroundColor(.red)
		Plotter(x, y2, line: .dashed(5)).foregroundColor(.blue)
	}
}

func step(_ x: [Scalar]) -> [Scalar] {
	return x.map { $0 > 0 }
}

func Step() -> Plotter {
	let x = arange(from: -5, to: 5, by: 0.1)
	let y = step(x)
	return Plotter(x, y)
}

struct ContentView: View {
    var body: some View {
		VStack {
			SinCos().border(.white).padding()
			Step().border(.white).padding()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
