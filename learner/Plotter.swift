//
//  Plotter.swift
//  Plotter
//
//  Created by dan lee on 2021/09/16.
//

import SwiftUI

extension CGPoint {
	init (x: Float, y: Float) {
		self = CGPoint(x: CGFloat(x), y: CGFloat(y))
	}
}

extension StrokeStyle {
	static func dashed(_ length: CGFloat) -> StrokeStyle {
		StrokeStyle.init(lineWidth: 2, dash: [length])
	}
}

struct Plotter: View {
	let x: [Scalar]
	let y: [Scalar]
	let points: [CGPoint]
	let line: StrokeStyle
	init (_ x: [Scalar], _ y: [Scalar], line: StrokeStyle = .init(lineWidth: 2)) {
		self.x = x
		self.y = y
		self.line = line
		points = x.indices
			.map { i in CGPoint(x: x[i], y: y[i]) }
			.sorted { $0.x < $1.x }
	}
    var body: some View {
		Graph(points).stroke(style: line)
			.padding()
			.frame(minHeight: 200)
	}
}

extension Array where Element == CGPoint {
	var maxX: CGFloat {
		var max: CGFloat = self[0].x
		for point in self {
			max = Swift.max(point.x, max)
		}
		return max
	}
	var maxY: CGFloat {
		var max: CGFloat = self[0].y
		for point in self {
			max = Swift.max(point.y, max)
		}
		return max
	}
	var minX: CGFloat {
		var min: CGFloat = self[0].x
		for point in self {
			min = Swift.min(point.x, min)
		}
		return min
	}
	var minY: CGFloat {
		var min: CGFloat = self[0].y
		for point in self {
			min = Swift.min(point.y, min)
		}
		return min
	}
}

struct Graph: Shape {
	let points: [CGPoint]
	
	init (_ points: [CGPoint]) {
		self.points = points
	}
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let minX = points[0].x
		let minY = points.minY
		let gapX = points.maxX - minX
		let gapY = points.maxY - minY
		let xScale = rect.maxX / gapX
		let yScale = rect.maxY / gapY
		let origin = CGPoint(x: 0, y: rect.maxY - (points[0].y - minY) * yScale)
		
		path.move(to: origin)
		for point in points.dropFirst() {
			let next = CGPoint(x: (point.x - minX) * xScale, y: rect.maxY - (point.y - minY) * yScale)
			path.addLine(to: next)
		}
		return path
	}
}

struct Plotter_Previews: PreviewProvider {
    static var previews: some View {
		Plotter([3, 2, 1], [1, 2, 3])
    }
}
