import Foundation

extension StringProtocol {

	static func typeName(_ type: Any.Type) -> String {
		String(reflecting: type)
			.components(separatedBy: ["<", ",", " ", ">", ":", "[", "]", "?"])
			.lazy
			.flatMap {
				var result = $0.components(separatedBy: ["."])
				if result.count > 1 {
					result.removeFirst()
				}
				return result
			}
			.flatMap {
				$0.components(separatedBy: .alphanumerics.inverted)
			}
			.joined()
	}

	func toCamelCase(separator: Character = "_") -> String {
        guard !self.isEmpty, let firstNonUnderscore = self.firstIndex(where: { $0 != separator })
        else { return .init(self) }

        var lastNonUnderscore = self.endIndex
        repeat {
            self.formIndex(before: &lastNonUnderscore)
        } while lastNonUnderscore > firstNonUnderscore && self[lastNonUnderscore] == separator

        let keyRange = self[firstNonUnderscore...lastNonUnderscore]
        let leading  = self[self.startIndex..<firstNonUnderscore]
        let trailing = self[self.index(after: lastNonUnderscore)..<self.endIndex]
        let words    = keyRange.split(separator: separator)

        guard words.count > 1 else {
            return "\(leading)\(keyRange)\(trailing)"
        }
        return "\(leading)\(([words[0].decapitalized] + words[1...].map(\.encapitalized)).joined())\(trailing)"
	}

	func toSnakeCase(separator: Character = "_") -> String {
        guard !self.isEmpty else { return .init(self) }
        var words: [Range<String.Index>] = []
        var wordStart = self.startIndex, searchIndex = self.index(after: wordStart)
        while let upperCaseIndex = self[searchIndex...].firstIndex(where: \.isUppercase) {
            words.append(wordStart..<upperCaseIndex)
            wordStart = upperCaseIndex
            guard let lowerCaseIndex = self[upperCaseIndex...].firstIndex(where: \.isLowercase) else {
                break
            }
            searchIndex = lowerCaseIndex
            if lowerCaseIndex != self.index(after: upperCaseIndex) {
                let beforeLowerIndex = self.index(before: lowerCaseIndex)
                words.append(upperCaseIndex..<beforeLowerIndex)
                wordStart = beforeLowerIndex
            }
        }
        words.append(wordStart..<self.endIndex)
        return words.map { self[$0].decapitalized }.joined(separator: "\(separator)")
	}

    /// Returns the string with its first character lowercased.
    private var decapitalized: String { self.isEmpty ? "" : "\(self[self.startIndex].lowercased())\(self.dropFirst())" }

    /// Returns the string with its first character uppercased.
    private var encapitalized: String { self.isEmpty ? "" : "\(self[self.startIndex].uppercased())\(self.dropFirst())" }
}
