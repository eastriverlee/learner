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

infix operator •
extension Array where Element == Scalar {
	init(count: UInt) {
		self = [Scalar](repeating: 0, count: Int(count))
	}
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
	static func •(lhs: [Scalar], rhs: [Scalar]) -> Scalar {
		vDSP.dot(lhs, rhs)
	}
	static func •<Element>(lhs: [[Scalar]], rhs: [Element]) -> [Element] {
		let m = vDSP_Length(lhs.width)
		let n = vDSP_Length(rhs.height)
		let p = vDSP_Length(rhs.width)
		
		let a = lhs.flatten()
		let b = rhs.flatten()
		var c = [Scalar](count: m*n)
		vDSP_mmul(a, 1, b, 1, &c, 1, m, n, p)
		if n == 1 { return c as! [Element] }
		return c.group(by: n) as! [Element]
	}
	func max() -> Scalar {
		vDSP.maximum(self)
	}
	func min() -> Scalar {
		vDSP.minimum(self)
	}
}

postfix operator ++
extension Int {
	postfix static func ++(n: inout Int) -> Int {
		let copy = n
		n += 1
		return copy
	}
}

extension Array {
	func group(by count: UInt) -> [[Element]] {
		var result: [[Element]] = []
		var current = 0
		while current < self.count {
			var component: [Element] = []
			for _ in 0..<count {
				component.append(self[current++])
			}
			result.append(component)
		}
		return result
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
	vForce.sin(array.flatten())
}
func cos<Element>(_ array: [Element]) -> [Scalar] {
	vForce.cos(array.flatten())
}
func step<Element>(_ array: [Element]) -> [Scalar] {
	array.flatten().map { $0 > 0 }
}
func sigmoid<Element>(_ array: [Element]) -> [Scalar] {
	return 1 / (1 + vForce.exp(array.flatten()))
}
func relu<Element>(_ array: [Element]) -> [Scalar] {
	max(0, array.flatten())
}

extension Array {
	func flatten() -> [Scalar] {
		if let array = self as? [Scalar] { return array }
		if let array = self as? [[Scalar]] { return array.flatMap { $0 } }
		return Array.flatten_(self) as! [Scalar]
	}

	private static func flatten_<Element>(_ array: [Element], from index: Int = 0) -> [Element] {
		guard index < array.count else { return [] }
		var flattened: [Element] = []

		if let array = array[index] as? [Element] {
			flattened = flattened + (array.flatten() as! [Element])
		} else {
			flattened.append(array[index])
		}
		return flattened + flatten_(array, from: index + 1)
	}
	var width: Int { count }
	var height: Int { 1 }
}

extension Array where Element == [Scalar] {
	var height: Int { self[0].count }
	
	var T: [[Scalar]] {
		var matrix = self.flatten()
		let m = vDSP_Length(self.width)
		let n = vDSP_Length(self.height)
		vDSP_mtrans(matrix, 1, &matrix, 1, m, n)
		return matrix.group(by: n)
	}
}
