import Foundation

public struct KeyEncodingStrategy {

	public let encode: (String) -> String
}

public extension KeyEncodingStrategy {

	static var `default`: KeyEncodingStrategy = .convertToSnakeCase

	static func custom(_ encode: @escaping (String) -> String) -> KeyEncodingStrategy {
		KeyEncodingStrategy(encode: encode)
	}

	static var convertToSnakeCase: KeyEncodingStrategy {
		.convertToSnakeCase(separator: "_")
	}

	static func convertToSnakeCase(separator: Character) -> KeyEncodingStrategy {
		.custom {
			$0.toSnakeCase(separator: separator)
		}
	}
}
