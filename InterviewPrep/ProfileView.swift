//
//  ContentView.swift
//  InterviewPrep
//
//  Created by Nick Deda on 9/23/25.
//

/*
 Create a SwiftUI view that will display
 - Profile Image
 - Username
 - Bio
 This information will come from the github rest API
 */

import SwiftUI
import Observation

enum GithubError: Error {
  case invalidURL
  case invalidResponse
  case invalidData
}

@Observable
final class ProfileModel {
  var user: GithubClient.GithubUser?
}

struct GithubClient {
  
  func fetchUser() async throws -> GithubUser {
    try await fetchUser(login: "morgan-vanv")
  }

  func fetchUser(login: String) async throws -> GithubUser {
    let endpoint = "https://api.github.com/users/\(login)"
    guard let url = URL(string: endpoint) else { throw GithubError.invalidURL }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw GithubError.invalidResponse
    }
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(GithubUser.self, from: data)
    } catch {
      throw GithubError.invalidData
    }
  }
  
  struct GithubUser: Codable {
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

struct ProfileView: View {
  @Bindable var model = ProfileModel()
  var githubClient: GithubClient
  let login: String
  
  var body: some View {
    VStack(spacing: 16) {
      Group {
        AsyncImage(url: URL(string: model.user?.avatarURL ?? "")) { image in
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
          Text(model.user?.login ?? "")
            .font(.title)
          Text(model.user?.bio ?? "")
            .font(.caption)
            .padding()
          Spacer()
        }
        .padding()
      }
      .padding()
    }
    .task {
      do {
        model.user = try await githubClient.fetchUser()
      } catch GithubError.invalidData {
        print("Invalid data")
      } catch GithubError.invalidURL {
        print("Invalid URL")
      } catch GithubError.invalidResponse {
        print("HTTP ERROR")
      } catch {
        print("Unexpected error: \(error)")
      }
    }
  }
}

#Preview {
  ProfileView(githubClient: GithubClient(), login: "morgan-vanv")
}
