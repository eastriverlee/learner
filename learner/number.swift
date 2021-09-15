import Foundation
import Accelerate

typealias Scalar = Float

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
}

func sum<Element>(_ array: [Element]) -> Scalar {
	vDSP.sum(array.flatten() as! [Scalar])
}
func sin<Element>(_ array: [Element]) -> [Scalar] {
	(array.flatten() as! [Scalar]).map { sin($0) }
}
func cos<Element>(_ array: [Element]) -> [Scalar] {
	(array.flatten() as! [Scalar]).map { cos($0) }
}


extension Array {
	func flatten() -> [Element] {
		if let array = self as? [Scalar] { return array as! [Element] }
		if let array = self as? [[Scalar]] { return array.flatMap { $0 } as! [Element] }
		return Array.flatten(self)
	}

	private static func flatten<Element>(_ array: [Element], from index: Int = 0) -> [Element] {
		guard index < array.count else { return [] }
		var flattened: [Element] = []

		if let array = array[index] as? [Element] {
			flattened = flattened + array.flatten()
		} else {
			flattened.append(array[index])
		}
		return flattened + flatten(array, from: index + 1)
	}
}
