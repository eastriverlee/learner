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

func ReLUSoftmax() -> some View {
	let x = arange(from: -5, to: 5, by: 0.1)
	let y1 = relu(x)
	let y2 = softmax(x)
	return ZStack {
		Plotter(x, y1).foregroundColor(.green)
		Plotter(x, y2, line: .dashed(5)).foregroundColor(.pink)
	}
}

let TRAIN = 0
let TEST = 1
private let dataset = MNIST()
private let images = dataset.images[TRAIN]
private let labels = dataset.labels[TRAIN]
let data = [Byte](images[0] as! Vector)
struct Bmp: View {
	let bitmap = Bitmap(width: 28, height: 28, bytes: data, channel: 1)
	var body: some View {
		Image(bitmap)
			.resizable()
			.aspectRatio(1, contentMode: .fit)
			.overlay(Text("\(labels.vector[0])").foregroundColor(.red))
	}
}

struct ContentView: View {
    var body: some View {
		VStack {
			Bmp()
//			SinCos().border(Color.white).padding()
//			SigmoidStep().border(Color.white).padding()
//			ReLUSoftmax().border(Color.white).padding()
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
}
