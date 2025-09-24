import SwiftUI
import SwiftNavigation
import Observation

@Observable
final class UserDetailsFeature: HashableObject {
	let user: GithubClient.UserDetails
	
	init(user: GithubClient.UserDetails) {
		self.user = user
	}
}

// MARK: - SwiftUI

struct UserDetailsView: View {
	@Bindable var model: UserDetailsFeature
	
	var body: some View {
		VStack(spacing: 16) {
			Group {
				AsyncImage(url: URL(string: self.model.user.avatarURL)) { image in
					image
						.resizable()
						.frame(width: 180, height: 180)
						.clipShape(Circle())
						.overlay(
							Circle().stroke(Color.gray, lineWidth: 2)
						)
						.shadow(radius: 4)
					
				} placeholder: {
					Image(systemName: "person.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 180, height: 180)
						.foregroundStyle(.secondary)
				}
				
				VStack {
					Text(self.model.user.login)
						.font(.title)
					Text(self.model.user.bio ?? "")
						.font(.caption)
						.padding()
					Spacer()
				}
				.padding()
			}
			.padding()
		}
	}
}

// MARK: - SwiftUI Previews
//
//#Preview("Kody") {
//	UserDetailsView(model: UserDetailsFeature(login: "kodydeda4"))
//}
//
//#Preview("Morgan") {
//	UserDetailsView(model: UserDetailsFeature(login: "morgan-vanv"))
//}
