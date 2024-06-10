# ZoomableImageVCPackage

ZoomableImageVCPackage is a Swift package for adding scrollable and image view functionality to your iOS projects.

## Features

- Easily scrollable and zoomable image view
- Smooth and responsive interactions with boundaries

## Integration

To integrate ImageViewScrollingPackage into your Xcode project using Swift Package Manager, follow these steps:

### Step 1: Add Package Dependency

1. Open your Xcode project.
2. Navigate to `File` > `Swift Packages` > `Add Package Dependency...`.
3. Paste the repository URL: [GitHub Repository URL].
4. Click `Next`.
5. Select the package and the version you want to use.
6. Click `Next`.
7. Choose the target(s) where you want to use the package.
8. Click `Finish`.

### Step 2: Import Package

In the Swift files where you want to use ZoomableImageVCPackage, import the package:

```swift
import ZoomableImageVC
```

### Step 3: Usage

In the Swift files where you want to use ImageViewScrollingPackage, import the package:

```swift
// Initialize with your own image.
guard let testImage = UIImage(named: "testImage) else { return }

let vc = ZoomableImageViewController(image: testImage)
vc.modalPresentationStyle = .fullScreen
present(vc, animated: true)
```

### Requirements
iOS 15.0+
Xcode 15.0+

### Contributions
Contributions are welcome! Please open an issue or submit a pull request for any bug fixes or feature requests.

### Licence
ZoomableImageVCPackage is available under the MIT license. See the LICENSE file for more information.
