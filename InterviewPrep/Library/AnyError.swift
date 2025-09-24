import Foundation

struct AnyError: Error, Equatable {
	let description: String
	
	init(_ description: String = String()) {
		self.description = description
	}
	
	init(error: Error) {
		self.description = error.localizedDescription
	}
}
