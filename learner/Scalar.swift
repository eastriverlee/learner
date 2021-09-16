import Foundation
import Accelerate

typealias Scalar = Float

extension Scalar {
	func broadcast(to target: [Scalar]) -> [Scalar] {
		var result = target
		vDSP.fill(&result, with: self)
		return result
	}
}

extension Array where Element == Scalar {
	static func +(lhs: [Scalar], rhs: [Scalar]) -> [Scalar] {
		vDSP.add(lhs, rhs)
	}
	static func -(lhs: [Scalar], rhs: [Scalar]) -> [Scalar] {
		vDSP.subtract(lhs, rhs)
	}
	static func *(lhs: [Scalar], rhs: [Scalar]) -> [Scalar] {
		vDSP.multiply(lhs, rhs)
	}
	static func /(lhs: [Scalar], rhs: [Scalar]) -> [Scalar] {
		vDSP.divide(lhs, rhs)
	}
	static func +(lhs: [Scalar], rhs: Scalar) -> [Scalar] {
		vDSP.add(rhs, lhs)
	}
	static func -(lhs: [Scalar], rhs: Scalar) -> [Scalar] {
		vDSP.add(-rhs, lhs)
	}
	static func *(lhs: [Scalar], rhs: Scalar) -> [Scalar] {
		vDSP.multiply(rhs, lhs)
	}
	static func /(lhs: [Scalar], rhs: Scalar) -> [Scalar] {
		vDSP.divide(lhs, rhs)
	}
	static func +(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		rhs.map { $0 + lhs }
	}
	static func -(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		rhs.map { $0 - lhs }
	}
	static func *(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		vDSP.multiply(lhs, rhs)
	}
	static func /(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		vDSP.divide(lhs, rhs)
	}
	static func +(lhs: [[Scalar]], rhs: [[Scalar]]) -> [[Scalar]] {
		lhs.indices.map{ lhs[$0] + rhs[$0] }
	}
	static func -(lhs: [[Scalar]], rhs: [[Scalar]]) -> [[Scalar]] {
		lhs.indices.map{ lhs[$0] - rhs[$0] }
	}
	static func *(lhs: [[Scalar]], rhs: [[Scalar]]) -> [[Scalar]] {
		lhs.indices.map{ lhs[$0] * rhs[$0] }
	}
	static func /(lhs: [[Scalar]], rhs: [[Scalar]]) -> [[Scalar]] {
		lhs.indices.map{ lhs[$0] / rhs[$0] }
	}
	func max() -> Scalar {
		vDSP.maximum(self)
	}
	func min() -> Scalar {
		vDSP.minimum(self)
	}
}
func max(_ x1: [Scalar], _ x2: [Scalar]) -> [Scalar] {
	vDSP.maximum(x1, x2)
}
func min(_ x1: [Scalar], _ x2: [Scalar]) -> [Scalar] {
	vDSP.minimum(x1, x2)
}
func max(_ x1: Scalar, _ x2: [Scalar]) -> [Scalar] {
	vDSP.threshold(x2, to: x1, with: .clampToThreshold)
}
func min(_ x1: Scalar, _ x2: [Scalar]) -> [Scalar] {
	vDSP.clip(x2, to: -.infinity...x1)
}
func max(_ x1: [Scalar], _ x2: Scalar) -> [Scalar] {
	vDSP.threshold(x1, to: x2, with: .clampToThreshold)
}
func min(_ x1: [Scalar], _ x2: Scalar) -> [Scalar] {
	vDSP.clip(x1, to: -.infinity...x2)
}

func sum<Element>(_ array: [Element]) -> Scalar {
	vDSP.sum(array.flatten())
}
func sin<Element>(_ array: [Element]) -> [Scalar] {
	array.flatten().map { sin($0) }
}
func cos<Element>(_ array: [Element]) -> [Scalar] {
	array.flatten().map { cos($0) }
}
func step<Element>(_ array: [Element]) -> [Scalar] {
	array.flatten().map { $0 > 0 }
}
func sigmoid<Element>(_ array: [Element]) -> [Scalar] {
	let e_x = (array.flatten()).map { exp(-$0) }
	return 1 / (1 + e_x)
}
func relu<Element>(_ array: [Element]) -> [Scalar] {
	max(0, array.flatten())
}


extension Array {
	func flatten() -> [Scalar] {
		if let array = self as? [Scalar] { return array }
		if let array = self as? [[Scalar]] { return array.flatMap { $0 } }
		return Array.flatten(self) as! [Scalar]
	}

	private static func flatten<Element>(_ array: [Element], from index: Int = 0) -> [Element] {
		guard index < array.count else { return [] }
		var flattened: [Element] = []

		if let array = array[index] as? [Element] {
			flattened = flattened + (array.flatten() as! [Element])
		} else {
			flattened.append(array[index])
		}
		return flattened + flatten(array, from: index + 1)
	}
}
