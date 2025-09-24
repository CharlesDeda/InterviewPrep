import Foundation

extension GithubClient {
	static var liveValue: Self {
		let controller = LiveValue()
		return Self(
			fetchUser: { login in
				try await controller.fetchUser(login: login)
			}
		)
	}
}

extension GithubClient {
	fileprivate struct LiveValue {
		
		func fetchUser(login: String) async throws -> UserDetails {
			let endpoint = "https://api.github.com/users/\(login)"
			guard let url = URL(string: endpoint) else { throw AnyError() }
			
			let (data, response) = try await URLSession.shared.data(from: url)
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw AnyError() }
			
			do {
				let decoder = JSONDecoder()
				return try decoder.decode(UserDetails.self, from: data)
			} catch {
				throw AnyError()
			}
		}
	}
}
