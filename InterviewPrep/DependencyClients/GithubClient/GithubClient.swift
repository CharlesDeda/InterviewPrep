import Foundation

struct GithubClient {
	var fetchUser: @Sendable (_ login: String) async throws -> UserDetails
}

extension GithubClient {
	
	struct User: Equatable, Hashable, Identifiable {
		var id: URL { url }
		let url: URL
		
		var login: String {
			guard let url = URL(string: url.absoluteString) else { return "" }
			let login = url.lastPathComponent
			return login
		}
	}
	
	struct UserDetails: Codable {
		let login: String
		let avatarURL: String
		let bio: String?
		
		enum CodingKeys: String, CodingKey {
			case login
			case avatarURL = "avatar_url"
			case bio
		}
	}
}

extension GithubClient.User {
	
	static let previewValue: [Self] = [
		Self(url: URL(string: "https://api.github.com/users/morgan-vanv").unsafelyUnwrapped),
		Self(url: URL(string: "https://api.github.com/users/apple").unsafelyUnwrapped),
		Self(url: URL(string: "https://api.github.com/users/torvalds").unsafelyUnwrapped),
		Self(url: URL(string: "https://api.github.com/users/nickdeda").unsafelyUnwrapped),
	]
}

