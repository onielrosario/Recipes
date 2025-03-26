# Fetch Recipe App 🍽️

## Summary

This SwiftUI-based recipe app fetches and displays recipes from different API endpoints. Users can:
- View a list of recipes (name, cuisine, and photo)
- Pull to refresh recipes
- Tap a toolbar button to simulate different API states (`all`, `empty`, `malformed`)
- See appropriate error or empty state messages
- Retry fetching via a "Try Again" button
- Experience smooth image loading with memory + disk caching (no third-party libraries)

### Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/76c11685-bcf6-4048-a099-87fd3ea1745b" width="300"/>
  <img src="https://github.com/user-attachments/assets/c463ced7-8deb-46b5-83ce-2b6f25fddc6a" width="300"/>
  <img src="https://github.com/user-attachments/assets/7ebdc315-8f0b-43c7-9a22-b43af4586a06" width="300"/>
</div>

---

## Focus Areas

### 🔹 Architecture & Testability
I prioritized a clean **MVVM architecture**, making use of protocol-based abstractions, dependency injection, and actor isolation for disk-safe image caching. This makes the app testable and easy to reason about.

### 🔹 Swift Concurrency
All async tasks are implemented using `async/await`, including image loading and network calls. I also handled Swift 6’s strict data race rules as much as I could by isolating shared resources properly with actors and the main actor.

### 🔹 Dev Experience
I added a `Menu` in the navigation toolbar to easily test different API scenarios (`all`, `empty`, and `malformed`). This makes it easy to simulate scenarios without modifying the code.

---

## Time Spent

I spent approximately **14 hours** on this take-home, spread over a few sessions:

| Area                         | Time     |
|------------------------------|----------|
| Project setup + architecture | ~2 hrs   |
| ViewModel + Views            | ~3 hrs   |
| Image caching (disk + memory)| ~3 hrs   |
| Testing & mocks              | ~4 hrs   |
| Polish, toolbar, README      | ~2 hrs |

---

## Trade-offs and Decisions

- ❗️ **No use of `URLCache` or 3rd-party**: I chose to implement my own image disk cache using `NSCache` + `FileManager` in an `actor`, in line with the requirements. This added complexity, but was a great opportunity to showcase concurrency safety.
- 🧪 For testing, I used Swift’s new `@Test` API (Xcode 15+), which aligns better with Swift’s direction and feels more natural in async-first codebases.

---

## Weakest Part of the Project

- I could improve the UI polish for error/empty/loading states with custom illustrations or more visual feedback.
While the image caching is robust, there’s no cache invalidation or size limit in this take-home version. I left extra implementations in image caching for clearing cached images, future improvements, and scaling plans.
- I skipped things like offline support or paginated loading to stay focused on the core requirements.

---

## Additional Information

- The app requires iOS 16+ due to SwiftUI and `NavigationStack` usage.
- I used actors and `@MainActor` judiciously to satisfy Swift 6’s stricter concurrency model, especially around `ObservableObject` properties.
- I structured the project with scalability in mind — it would be easy to plug in new endpoints, features, or deeper models.

### Accessibility

The app includes basic accessibility support to ensure a better experience for VoiceOver users:

- Images are labeled appropriately or hidden from assistive tech if decorative.
- Buttons have descriptive labels for actions like retrying and switching endpoints.
- Further enhancements like dynamic text scaling and color contrast adjustments would be considered in a full production app.

Thanks for reviewing my take-home — it was a fun challenge and a great opportunity to demonstrate my approach to clean, testable, and user-friendly iOS apps.
