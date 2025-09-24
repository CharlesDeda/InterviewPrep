import SwiftUI
import SwiftUINavigation
import ConcurrencyExtras

@MainActor
@Observable
final class AppModel {
	
	@CasePathable
	enum Destination {
		case userDetails(UserDetailsFeature)
	}
	
	var destination: Destination?
	var inFlightId: GithubClient.User.ID?
	let users = GithubClient.User.previewValue
	let githubClient = GithubClient.liveValue
	
	func userButtonTapped(_ value: GithubClient.User) {
		self.inFlightId = value.id
		
		Task {
			await self.userResponse(Result {
				try await self.githubClient.fetchUser(value.login)
			})
		}
	}
	
	private func userResponse(
		_ value: Result<GithubClient.UserDetails, Error>
	) {
		self.inFlightId = .none
		switch value {
		case let .success(value):
			self.destination = .userDetails(UserDetailsFeature(user: value))
		case let .failure(error):
			print(error.localizedDescription)
		}
	}
}

// MARK: - SwiftUI

struct AppView: View {
	@State var model: AppModel
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(self.model.users) { value in
					Button(action: { self.model.userButtonTapped(value) }) {
						self.row(value)
					}
					.buttonStyle(.plain)
				}
			}
			.navigationTitle("Users")
			.navigationBarTitleDisplayMode(.inline)
			.navigationDestination(item: $model.destination.userDetails) { model in
				UserDetailsView(model: model)
			}
		}
	}

	private func row(_ value: GithubClient.User) -> some View {
		HStack(spacing: 12) {
			Image(systemName: "person.circle")
				.resizable()
				.scaledToFit()
				.frame(width: 36, height: 36)
				.clipShape(Circle())
			
			VStack(alignment: .leading, spacing: 2) {
				Text(value.login.isEmpty ? "Unknown" : value.login)
					.fontWeight(.bold)
				Text(value.url.description)
					.font(.footnote)
					.foregroundStyle(.secondary)
					.lineLimit(1)
			}
			
			Spacer()
			
			if value.id == self.model.inFlightId {
				ProgressView()
			}
		}
		.padding(.vertical, 4)
	}
}

// MARK: - SwiftUI Previews

#Preview {
	AppView(model: AppModel())
}

