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

func SigmoidStep() -> some View {
	let x = arange(from: -5, to: 5, by: 0.1)
	let y1 = sigmoid(x)
	let y2 = step(x)
	return ZStack {
		Plotter(x, y1).foregroundColor(.yellow)
		Plotter(x, y2, line: .dashed(5))
	}
}

func ReLU() -> some View {
	let x = arange(from: -5, to: 5, by: 0.1)
	let y = relu(x)
	return ZStack {
		Plotter(x, y).foregroundColor(.green)
	}
}


struct ContentView: View {
    var body: some View {
		VStack {
			SinCos().border(.white).padding()
			SigmoidStep().border(.white).padding()
			ReLU().border(.white).padding()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Brain {
	var weigth: [Tensor] = []
	var bias: [Tensor] = []
}

func forward(_ input: Tensor) -> Tensor {
	
	let W1 = Tensor([[0.1, 0.3, 0.5], [0.2, 0.4, 0.6]])
	let W2 = Tensor([[0.1, 0.4], [0.2, 0.5], [0.3, 0.6]])
	let W3 = Tensor([[0.1, 0.3], [0.2, 0.4]])
	
	let b1 = Tensor([0.1, 0.2, 0.3])
	let b2 = Tensor([0.1, 0.2])
	let b3 = Tensor([0.1, 0.2])
	
	let a1 = input•W1 + b1
	let z1 = sigmoid(a1)
	
	let a2 = z1•W2 + b2
	let z2 = sigmoid(a2)
	
	let a3 = z2•W3 + b3
	let output = a3
	return output
}

func test() {
	let input = Tensor([1, 0.5])
	let output = forward(input)
	print(output)
}
