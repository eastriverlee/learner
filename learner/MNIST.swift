//
//  MNIST.swift
//  learner
//
//  Created by dan lee on 2021/09/24.
//

import Foundation
import System

let mnist = "http://yann.lecun.com/exdb/mnist/"
let files: KeyValuePairs = [
	"train_img": "train-images-idx3-ubyte.gz",
	"train_label": "train-labels-idx1-ubyte.gz",
	"test_img": "t10k-images-idx3-ubyte.gz",
	"test_label": "t10k-labels-idx1-ubyte.gz"
]
private var images: [Tensor] = []
private var labels: [Tensor] = []

extension Data {
	func bytes(offsetBy offset: Int = 0) -> [Byte] {
		Array(self.dropFirst(offset))
	}
}
extension String {
	var isExistingPath: Bool {
		let (status, _) = shell("ls \(self)")
		return status == 0
	}
}
let imageSize: UInt = 784
func gunzip(_ fileName: String, offsetBy offset: Int = 0) -> [Byte] {
	let unzipped = "~/Documents/\(fileName.dropLast(3))-raw"
	if !unzipped.isExistingPath {
		shell("gzip -dc ~/Documents/\(fileName) > \(unzipped)")
	}
	let data = try! Data(contentsOf: URL(fileURLWithPath: String(unzipped.dropFirst(2))))
	return Array(data.dropFirst(offset))
}
func load(image fileName: String) -> Tensor {
	let data = gunzip(fileName, offsetBy: 16)
	let vectors = Vector(data).group(by: imageSize)
	return Tensor(vectors)
}
func load(label fileName: String) -> Tensor {
	let data = gunzip(fileName, offsetBy: 8)
	let vector = Vector(data)
	return Tensor(vector)
}

func download(_ fileName: String) {
	let command = "curl -o ~/Documents/\(fileName) \(mnist + fileName)"
	shell(command)
}

func normalize(_ target: String) {
	images[0] /= 255
	images[1] /= 255
}

func MNIST() -> (images: [Tensor], labels: [Tensor]) {
	for (key, fileName) in files {
		download(fileName)
		key.hasSuffix("img") ? images.append(load(image: fileName)) : labels.append(load(label: fileName))
		//normalize(key)
	}
	return (images, labels)
}
