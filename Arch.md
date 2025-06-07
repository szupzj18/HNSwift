# Architecture Overview

This document summarizes the structure of the **HNSwift** project, an iOS client for Hacker News written entirely in SwiftUI. It complements the information in `README.md` and gives a high‑level view of the code organization.

## Project Layout

```
HNSwift/             Swift source files
HNSwiftTests/        Unit tests
HNSwiftUITests/      UI tests
assets/              App icons
doc/                 Documentation images
HNSwift.xcodeproj/   Xcode project
```

### Source Subdirectories

- **Model** – Data models and persistence helpers. Includes the `Post` struct and `BookmarkManager` for saving bookmarks using `UserDefaults`.
- **Service** – Networking logic. `PostService` fetches IDs and details from the Hacker News API using Swift's async/await.
- **ViewModel** – View models used by SwiftUI views. Currently contains `PostSearchViewModel` for in‑app search filtering.
- **View** – SwiftUI views composing the UI. Key views include:
  - `ContentView` – App entry with tab navigation for Top and Show feeds.
  - `TopView` folder – Contains `HNFeedView` and device‑specific variants (`HNFeedViewiPhone`, `HNFeedViewPad`, `HNFeedViewBase`).
  - Supporting screens such as `MarkPostsView` for bookmarks and `ErrorView` for error messages.
- **Components** – Reusable view components such as `PostItemView`, `SafariView`, `LoadingView`, `SettingsView`, and toast notifications.

## Application Flow

1. **Entry Point** – `HNSwiftApp` launches `ContentView`, which sets up a `TabView` with Top and Show feeds. A shared `BookmarkManager` is injected via `EnvironmentObject`.
2. **Data Fetching** – `PostService` retrieves top and show stories. `HNFeedViewBase` requests posts on load, sorts them by score, and displays them in a list.
3. **Navigation** – On iPhone, tapping a post presents a sheet with `SafariView`. On iPad, `NavigationSplitView` is used to show a sidebar list and detail pane.
4. **Bookmarking and Search** – Users can bookmark posts or search through results locally. Bookmarks persist in `UserDefaults`.
5. **Testing** – The `HNSwiftTests` target uses `MockURLProtocol` to stub network requests, with tests for `PostService` and the `Post` model. UI test stubs are provided under `HNSwiftUITests`.

## Further Reading

Refer to `README.md` for screenshots and feature highlights. The project is a concise example of modern SwiftUI patterns combined with async/await networking and simple persistence.
