# iOS App Project: picsum-photo

## Notes
This app is built using UIKit without any third-party libraries. It focuses on providing a smooth user experience by optimizing native iOS features.

## Features
- **Image Caching**: Implements image caching to reduce lag and enhance performance.
- **Default Images**: Uses default placeholder images to ensure the app remains responsive while images load.

## Design Patterns

- **Clean Architecture & MVVM**: 
  - The project is structured using Clean Architecture principles combined with the MVVM (Model-View-ViewModel) pattern. This separation of concerns ensures a modular and maintainable codebase.

- **Singleton Pattern**:
  - `NetworkService` is implemented as a Singleton to manage network requests efficiently across the app.

- **Decorator Pattern**:
  - Extensions on native modules like `String` and `UIImageView` are implemented using the Decorator pattern, adding functionality without altering the original class structure.

- **Delegation Pattern**:
  - The ViewModel uses the Delegation pattern to notify the UI when the table view needs to be updated, ensuring a clear separation of logic and presentation.
