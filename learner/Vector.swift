import Foundation
import Accelerate

typealias Scalar = Float
typealias Vector = [Scalar]

infix operator .+
infix operator •: MultiplicationPrecedence	/// option + 8
prefix operator ∑							/// option + w
extension Array where Element == Byte {
	init(_ vector: [Scalar]) {
		self = vDSP.floatingPointToInteger(vector, integerType: Byte.self, rounding: .towardNearestInteger)	}
}
extension Vector {
	init(_ bytes: [Byte]) {
		self = vDSP.integerToFloatingPoint(bytes, floatingPointType: Scalar.self)
	}
	init(count: Int, as value: Scalar? = nil) {
		self.init(repeating: value ?? 0, count: count)
	}
	init(count: UInt, as value: Scalar? = nil) {
		self.init(count: Int(count), as: value)
	}
	mutating func replace(with value: Scalar) {
		vDSP.fill(&self, with: value)
	}
	static func .+(lhs: [Scalar], rhs: [Scalar]) -> [Scalar] {
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
		vDSP.add(lhs, rhs)
	}
	static func -(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		vDSP.add(lhs, -rhs)
	}
	static func *(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		vDSP.multiply(lhs, rhs)
	}
	static func /(lhs: Scalar, rhs: [Scalar]) -> [Scalar] {
		vDSP.divide(lhs, rhs)
	}
	static func •(lhs: [Scalar], rhs: [Scalar]) -> Scalar {
		vDSP.dot(lhs, rhs)
	}
	static prefix func -(rhs: [Scalar]) -> [Scalar] {
		vDSP.multiply(-1, rhs)
	}
	static prefix func ∑(rhs: [Scalar]) -> Scalar {
		vDSP.sum(rhs)
	}
	static func /=(lhs: inout [Scalar], rhs: [Scalar]) {
		lhs = lhs / rhs
	}
	static func *=(lhs: inout [Scalar], rhs: [Scalar]) {
		lhs = lhs * rhs
	}
	static func +=(lhs: inout [Scalar], rhs: [Scalar]) {
		lhs = lhs + rhs
	}
	static func -=(lhs: inout [Scalar], rhs: [Scalar]) {
		lhs = lhs - rhs
	}
	static func /=(lhs: inout [Scalar], rhs: Scalar) {
		lhs = lhs / rhs
	}
	static func *=(lhs: inout [Scalar], rhs: Scalar) {
		lhs = lhs * rhs
	}
	static func +=(lhs: inout [Scalar], rhs: Scalar) {
		lhs = lhs + rhs
	}
	static func -=(lhs: inout [Scalar], rhs: Scalar) {
		lhs = lhs - rhs
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
func sum(_ array: [Scalar]) -> Scalar {
	vDSP.sum(array)
}
func sin(_ array: [Scalar]) -> [Scalar] {
	vForce.sin(array)
}
func cos(_ array: [Scalar]) -> [Scalar] {
	vForce.cos(array)
}
func exp(_ array: [Scalar]) -> [Scalar] {
	vForce.exp(array)
}
func step(_ array: [Scalar]) -> [Scalar] {
	array.map { $0 > 0 }
}
func sigmoid(_ array: [Scalar]) -> [Scalar] {
	return 1 / (1 + exp(-array))
}
func relu(_ array: [Scalar]) -> [Scalar] {
	max(0, array)
}
func softmax(_ array: [Scalar]) -> [Scalar] {
	let c = array.max()
	let exp_a = exp(array - c)
	return exp_a / sum(exp_a)
}
extension Vector {
	func reconstruct(as shape: [UInt]) -> Any {
		var result: [Any] = self
		let dimension = shape.count
		for n in 1..<dimension {
			result = shape[n] == 1 ? result : result.group(by: shape[n])
		}
		return result
	}
}
