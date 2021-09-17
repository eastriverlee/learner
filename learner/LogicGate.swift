//
//  LogicGate.swift
//  LogicGate
//
//  Created by dan lee on 2021/09/16.
//

import Foundation

extension Scalar {
	static func >(x1: Scalar, x2: Scalar) -> Scalar {
		x1 > x2 ? 1 : 0
	}
	static func <(x1: Scalar, x2: Scalar) -> Scalar {
		x1 < x2 ? 1 : 0
	}
	static func >=(x1: Scalar, x2: Scalar) -> Scalar {
		x1 >= x2 ? 1 : 0
	}
	static func <=(x1: Scalar, x2: Scalar) -> Scalar {
		x1 <= x2 ? 1 : 0
	}
	static func ==(x1: Scalar, x2: Scalar) -> Scalar {
		x1 == x2 ? 1 : 0
	}
	static func !=(x1: Scalar, x2: Scalar) -> Scalar {
		x1 != x2 ? 1 : 0
	}
	static prefix func !(x: Scalar) -> Scalar {
		x == 1 ? 0 : 1
	}
}

infix operator !&
infix operator !|
infix operator ^^
extension Scalar {
	static func &&(x1: Scalar, x2: Scalar) -> Scalar {
		let x: [Scalar] = [x1, x2]
		let w: Scalar = 0.5
		let b: Scalar = -0.75
		return sum(w*x) + b > 0
	}
	static func !&(x1: Scalar, x2: Scalar) -> Scalar {
		let x: [Scalar] = [x1, x2]
		let w: Scalar = -0.5
		let b: Scalar = 0.75
		return sum(w*x) + b > 0
	}
	static func ||(x1: Scalar, x2: Scalar) -> Scalar {
		let x: [Scalar] = [x1, x2]
		let w: Scalar = 0.5
		let b: Scalar = -0.25
		return sum(w*x) + b > 0
	}
	static func !|(x1: Scalar, x2: Scalar) -> Scalar {
		let x: [Scalar] = [x1, x2]
		let w: Scalar = -0.5
		let b: Scalar = 0.25
		return sum(w*x) + b > 0
	}
	static func ^^(x1: Scalar, x2: Scalar) -> Scalar {
		let nand = x1 !& x2
		let or = x1 || x2
		return nand && or
	}
}

func test() {
	print("AND")
	print(0 && 0)
	print(1 && 0)
	print(0 && 1)
	print(1 && 1)
	print()
	
	print("NAND")
	print(0 !& 0)
	print(1 !& 0)
	print(0 !& 1)
	print(1 !& 1)
	print()
	
	print("OR")
	print(0 || 0)
	print(1 || 0)
	print(0 || 1)
	print(1 || 1)
	print()
	
	print("NOR")
	print(0 !| 0)
	print(1 !| 0)
	print(0 !| 1)
	print(1 !| 1)
	print()
	
	print("XOR")
	print(0 ^^ 0)
	print(1 ^^ 0)
	print(0 ^^ 1)
	print(1 ^^ 1)
	print()
	
	let a: [[Scalar]] = [[1, 2], [3, 4]]
	let b: [[Scalar]] = [[5, 6], [7, 8]]
	let c: [[Scalar]] = [[1, 2], [3, 4], [5, 6]]
	let d: [Scalar] = [7, 8]
	print(a • b)
	print(c • d)
	let e: [Scalar] = [1, 2]
	let f: [[Scalar]] = [[1, 3, 5], [2, 4, 6]]
	print(e • f)
}
