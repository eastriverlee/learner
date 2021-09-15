//
//  ContentView.swift
//  Shared
//
//  Created by dan lee on 2021/09/15.
//

import Foundation
import SwiftUI
import SwiftPlot
import SVGRenderer
import AGGRenderer

let x = Array(stride(from: Scalar(0), to: 6, by: 0.1))
let y1 = sin(x)
let y2 = cos(x)

class Plotter {
	var renderer = SVGRenderer()
	var graph = LineGraph<Scalar, Scalar>()
	
	init(_ title: String = "", x: String = "x", y: String = "y") {
		graph.plotLabel.xLabel = x
		graph.plotLabel.yLabel = y
		graph.plotTitle.title = title
		graph.plotLineThickness = 3.0
	}
	
	func plot(_ x: [Scalar], _ y: [Scalar], label: String = "", color: SwiftPlot.Color = .lightBlue) {
		graph.addSeries(x, y, label: label, color: color)
	}
	func show() -> SVG {
		let filename = "graph"
		let path = FileManager.default.currentDirectoryPath
		try! graph.drawGraphAndOutput(fileName: filename, renderer: renderer)
		let content = try! String(contentsOf: URL(fileURLWithPath: "\(path)/\(filename).svg"))
		return SVG(content)
	}
}

func Graph(_ title: String) -> SVG {
	let plotter = Plotter(title)
	plotter.plot(x, y1, label: "sin", color: .lightBlue)
	plotter.plot(x, y2, label: "cos", color: .gold)
	return plotter.show()
}

struct ContentView: View {
    var body: some View {
		Graph("svg & cos")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
