//
//  Extension.swift
//  Extension
//
//  Created by dan lee on 2021/09/17.
//

import Foundation
import Accelerate

postfix operator ++
postfix func ++<Number: Numeric>(n: inout Number) -> Number {
	let copy = n
	n += 1
	return copy
}

extension Array {
	mutating func prepend(_ array: Element) {
		self = [array] + self
	}
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
	subscript(i: UInt) -> Element {
		self[Int(i)]
	}
	subscript(safe i: Int) -> Element? {
		indices.contains(i) ? self[i] : nil
	}
	init(repeating element: Element, count: UInt) {
		self = Array.init(repeating: element, count: Int(count))
	}
	func flatten() -> [Scalar] {
		if let array = self as? [Scalar] { return array }
		if let array = self as? [[Scalar]] { return array.flatMap { $0 } }
		return flatten(self, from: 0) as! [Scalar]
	}

	private func flatten(_ array: [Any], from index: Int) -> [Any] {
		guard index < array.count else { return [] }
		var flattened: [Any] = []

		if let array = array[index] as? [Any] {
			flattened = flattened + array.flatten()
		} else {
			flattened.append(array[index])
		}
		return flattened + flatten(array, from: index + 1)
	}
	var width: Int { count }
	var height: Int { 1 }
}
