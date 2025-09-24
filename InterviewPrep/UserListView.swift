//
//  UserListView.swift
//  InterviewPrep
//
//  Created by Nick Deda on 9/24/25.
//

import SwiftUI
import Observation

struct User: Identifiable {
  var id = UUID()
  var avatar: Image = Image(systemName: "person.circle")
  var name: String
  var email: String
}

@MainActor
@Observable
final class UserListModel {
  var endpoints: [String] = [
    "https://api.github.com/users/morgan-vanv",
    "https://api.github.com/users/apple",
    "https://api.github.com/users/torvalds",
    "https://api.github.com/users/nickdeda"
  ]
  
  func refreshButtonTapped() {
    Task {
      self.endpoints.shuffle()
    }
  }
}

private func githubLogin(from endpoint: String) -> String {
  guard let url = URL(string: endpoint) else { return "" }
  let login = url.lastPathComponent
  return login
}

struct UserListView: View {
  @State var model = UserListModel()
  
  var body: some View {
    NavigationStack {
      List {
        if !model.endpoints.isEmpty {
          ForEach(model.endpoints, id: \.self) { endpoint in
            let login = githubLogin(from: endpoint)
            NavigationLink {
              ProfileView(githubClient: GithubClient(), login: login)
            } label: {
              HStack(spacing: 12) {
                Image(systemName: "person.circle")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 36, height: 36)
                  .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                  Text(login.isEmpty ? "Unknown" : login)
                    .fontWeight(.bold)
                  Text(endpoint)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                }
              }
              .padding(.vertical, 4)
            }
          }
        } else {
          Text("No users found.")
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .navigationTitle("Users")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button("Refresh") {
          model.refreshButtonTapped()
        }
      }
    }
  }
}

#Preview {
  UserListView()
}

