//
//  Tensor.swift
//  Tensor
//
//  Created by dan lee on 2021/09/17.
//

import Foundation
import Accelerate

class Tensor {
	private var _vector: [Scalar]
	private var _scalar: Scalar?
	private var _shape: [UInt] = []
	private var _dimension: UInt = 0
	
	private init(from array: [Any]) {
		_vector = array.flatten()
		_scalar = nil
		retrieveShape(from: array)
		_dimension = UInt(_shape.count)
	}
	init(_ scalar: Scalar) {
		_vector = []
		_scalar = scalar
		_shape = [1]
		_dimension = 1
	}
	init(_ vector: [Scalar], shape: [UInt]) {
		_vector = vector
		_scalar = nil
		_shape = shape
		_dimension = UInt(_shape.count)
	}
	convenience init(_ vector: [Scalar], shape: UInt) {
		self.init(vector, shape: [shape])
	}
	convenience init(_ array: [Scalar]) {
		self.init(from: array)
	}
	convenience init(_ array: [[Scalar]]) {
		self.init(from: array)
	}
	convenience init(_ array: [[[Scalar]]]) {
		self.init(from: array)
	}
	
	var value: Any { get { _dimension == 1 ? _scalar! : _vector } }
	var vector: [Scalar] { get { _vector } }
	var scalar: Scalar { get { _scalar! } }
	var dimension: UInt { get { _dimension } }
	var shape: [UInt] { get { _shape } }
	var width: UInt { get { _shape[_shape.endIndex - 1] } }
	var height: UInt { get { _shape[safe: _shape.endIndex - 2] ?? 1 } }
	
	private func retrieveShape(from array: [Any]) {
		_shape.append(UInt(array.count))
		if let array = array[0] as? [Any] {
			retrieveShape(from: array)
		}
	}
	func reshape(as shape: [UInt]) {
		self._shape = shape
		self._dimension = UInt(shape.count)
	}
	@inlinable
	func reshape(as shape: UInt) {
		reshape(as: [shape])
	}
	var copy: Tensor {
		Tensor(vector, shape: shape)
	}
	func transpose() {
		assert(dimension <= 2, "not a matrix")
		vDSP_mtrans(vector, 1, &_vector, 1, height, width)
		reshape(as: [width, height])
	}
	var T: Tensor {
		let t = copy
		t.transpose()
		return t
	}
}
extension Tensor {
	static func +(lhs: Tensor, rhs: Tensor) -> Tensor {
		Tensor(lhs.vector .+ rhs.vector, shape: lhs.shape)
	}
	static func -(lhs: Tensor, rhs: Tensor) -> Tensor {
		Tensor(lhs.vector - rhs.vector, shape: lhs.shape)
	}
	static func *(lhs: Tensor, rhs: Tensor) -> Tensor {
		Tensor(lhs.vector * rhs.vector, shape: lhs.shape)
	}
	static func /(lhs: Tensor, rhs: Tensor) -> Tensor {
		Tensor(lhs.vector / rhs.vector, shape: lhs.shape)
	}
	static func •(lhs: Tensor, rhs: Tensor) -> Tensor {
		let isLeftSmaller = lhs.dimension < rhs.dimension
		let isRightSmaller = rhs.dimension < lhs.dimension
		let isSame = !isLeftSmaller || !isRightSmaller
		let m = lhs.height
		let n = isRightSmaller ? 1 : rhs.width
		let p = lhs.width
		assert(p == (isRightSmaller ? rhs.width : rhs.height), "not dottable")
		let count = m * n
		var dotted = [Scalar](count: count)
		let shape: [UInt] = isSame ? [m, n] : [count]
		var result: [Scalar] = []
		if Swift.max(lhs.dimension, rhs.dimension) <= 2 {
			vDSP_mmul(lhs.vector, 1, rhs.vector, 1, &dotted, 1, m, n, p)
			return Tensor(dotted, shape: shape)
		}
		let commonShape = lhs._shape.dropLast(isSame ? 2 : 1)
		assert(commonShape == rhs._shape.dropLast(isRightSmaller ? 1 : 2), "different shape")
		let leftMatrices = lhs.vector.group(by: m * p)
		let rightMatrices = rhs.vector.group(by: p * n)
		for i in leftMatrices.indices {
			vDSP_mmul(leftMatrices[i], 1, rightMatrices[i], 1, &dotted, 1, m, n, p)
			result += dotted
		}
		return Tensor(result, shape: commonShape + shape)
	}
	func max() -> Scalar {
		self.vector.max()
	}
	func min() -> Scalar {
		self.vector.min()
	}
	static func stack(_ tensors: [Tensor]) -> Tensor {
		var shape = tensors[0].shape
		assert(tensors.allSatisfy { shape == $0.shape }, "different shape")
		var vector: [Scalar] = []
		for tensor in tensors {
			vector += tensor.vector
		}
		shape.prepend(UInt(tensors.count))
		return Tensor(vector, shape: shape)
	}
}
extension Tensor: CustomStringConvertible {
	private func reconstruct(as shape: [UInt]) -> Any {
		var result: [Any] = vector
		if let scalar = _scalar {
			result = [Scalar](count: shape.reduce(1, *), as: scalar)
		}
		for n in 1..<dimension {
			result = shape[n] == 1 ? result : result.group(by: shape[n])
		}
		return result
	}
	var description: String {
		_scalar != nil ? "\(scalar)" : "\(reconstruct(as: shape))"
	}
}

func tensor() {
	let a = Tensor([[[1, 2, 3], [3, 4, 3]] , [[1, 2, 3], [3, 4, 3]]])
	print(a)
	print(a.shape)
	print(a.dimension)
	let b = Tensor(3)
	print(b)
	b.reshape(as: [3, 2])
	print(b)
	b.reshape(as: 1)
	print(b)
}
