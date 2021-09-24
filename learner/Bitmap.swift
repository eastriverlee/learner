//
//  Bitmap.swift
//  learner
//
//  Created by dan lee on 2021/09/24.
//

import Foundation
import SwiftUI

typealias Byte = UInt8
class Bitmap {
	let bytes: [Byte]
	let channel: Int
	let width: Int
	let height: Int
	init(width: Int, height: Int, bytes: [Byte], channel: Int = 4) {
		self.width = width
		self.height = height
		self.bytes = bytes
		self.channel = channel
	}
}
extension Image {
	init(_ bitmap: Bitmap, alpha: Bool = false) {
		let bytesPerPixel = MemoryLayout<Byte>.size * bitmap.channel
		let bytesPerRow = bitmap.width * bytesPerPixel
		let provider = CGDataProvider(data: Data(bytes: bitmap.bytes, count: bitmap.height * bytesPerRow) as CFData)!
		let colorSpace = bitmap.channel >= 3 ? CGColorSpaceCreateDeviceRGB() : CGColorSpaceCreateDeviceGray()
		let bitmapInfo = CGBitmapInfo(rawValue: (alpha ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.none).rawValue)
		let raw = CGImage(
			width: bitmap.width,
			height: bitmap.height,
			bitsPerComponent: 8,
			bitsPerPixel: bytesPerPixel * 8,
			bytesPerRow: bytesPerRow,
			space: colorSpace,
			bitmapInfo: bitmapInfo,
			provider: provider,
			decode: nil,
			shouldInterpolate: true,
			intent: .defaultIntent
		)!
		self = Image(decorative: raw, scale: 1)
	}
}
