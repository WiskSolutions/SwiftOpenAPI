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
        guard !isEmpty else { return "" }
        var result = ""
        // Whether we should append a separator when we see a uppercase character.
        var separateOnUppercase = true
        for index in indices {
            let nextIndex = self.index(after: index)
            let character = self[index]
            if character.isUppercase {
                if separateOnUppercase, !result.isEmpty {
                    // Append the separator.
                    result += "\(separator)"
                }
                // If the next character is uppercase and the next-next character is lowercase, like "L" in "URLSession", we should separate words.
                separateOnUppercase = nextIndex < endIndex && self[nextIndex].isUppercase && self.index(after: nextIndex) < endIndex && self[self.index(after: nextIndex)].isLowercase
            } else {
                // If the character is `separator`, we do not want to append another separator when we see the next uppercase character.
                separateOnUppercase = character != separator
            }
            // Append the lowercased character.
            result += character.lowercased()
        }
        return result
	}

    /// Returns the string with its first character lowercased.
    private var decapitalized: String { self.isEmpty ? "" : "\(self[self.startIndex].lowercased())\(self.dropFirst())" }

    /// Returns the string with its first character uppercased.
    private var encapitalized: String { self.isEmpty ? "" : "\(self[self.startIndex].uppercased())\(self.dropFirst())" }
}
